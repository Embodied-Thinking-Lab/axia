use gtk::prelude::*;
use relm4::prelude::*;

#[derive(Clone, Copy, Debug)] 
struct RobotState {
    joint1: f64,
    joint2: f64,
    joint3: f64,
    joint4: f64,
    joint5: f64,
    joint6: f64,
}

impl Default for RobotState {
    fn default() -> Self {
        Self {
            joint1: 90.0,
            joint2: 90.0,
            joint3: 90.0,
            joint4: 90.0,
            joint5: 90.0,
            joint6: 90.0,
        }
    }
}

// holds current state and default state (for reset btn)
struct AppModel {
    current: RobotState,
    defaults: RobotState,
}

#[derive(Debug)]
enum AppMsg {
    UpdateAngle1(f64),
    UpdateAngle2(f64),
    UpdateAngle3(f64),
    UpdateAngle4(f64),
    UpdateAngle5(f64),
    UpdateAngle6(f64),
    Reset,
}

#[relm4::component]
impl SimpleComponent for AppModel {
    type Init = f64;
    type Input = AppMsg;
    type Output = ();

    view! {
        gtk::Window {
            set_title: Some("AXIA-OS Control Panel"),
            set_default_size: (300, 150),

            gtk::Box {
                set_orientation: gtk::Orientation::Vertical,
                set_spacing: 10,
                set_margin_all: 15,

                gtk::Box {
                    set_orientation: gtk::Orientation::Horizontal,
                    set_hexpand: true,
        
                
                    gtk::Scale::with_range(gtk::Orientation::Horizontal, -180.0, 180.0, 1.0) {
                        set_hexpand: true,
                        set_draw_value: false,

               
                        connect_value_changed[sender] => move |scale| {
                            sender.input(AppMsg::UpdateAngle1(scale.value()));
                        }
                    },
                },

                gtk::Button {
                    set_label: "Reset to Default Positions",
                    connect_clicked => AppMsg::Reset,
                }
            }
        }
    }

fn init(
        init_value: Self::Init, 
        root: Self::Root,
        sender: ComponentSender<Self>,
    ) -> ComponentParts<Self> {
        // create the default state 
        let defaults = RobotState::default();

        // create and init current state
        let current = RobotState {
            joint1: init_value,
            joint2: init_value,
            joint3: init_value,
            joint4: init_value,
            joint5: init_value,
            joint6: init_value,
        };

        // init AppModel
        let model = AppModel { current, defaults };
        let widgets = view_output!();

        ComponentParts { model, widgets }
    }

    // handle incoming UI msgs
    fn update(&mut self, msg: Self::Input, _sender: ComponentSender<Self>) {
        match msg {
            AppMsg::UpdateAngle1(val) => self.current.joint1 += val,
            AppMsg::UpdateAngle2(val) => self.current.joint2 += val,
            AppMsg::UpdateAngle3(val) => self.current.joint3 += val,
            AppMsg::UpdateAngle4(val) => self.current.joint4 += val,
            AppMsg::UpdateAngle5(val) => self.current.joint5 += val,
            AppMsg::UpdateAngle6(val) => self.current.joint6 += val,



            AppMsg::Reset => {
                self.current = self.defaults;
            }, 
        }
    }
}

fn main() {
    let app = RelmApp::new("com.axia.control");
    app.run::<AppModel>(0.0);
}
