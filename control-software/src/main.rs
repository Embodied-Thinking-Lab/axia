use gtk::prelude::*;
use relm4::prelude::*;

const JOINT1_DEFAULT: f64 = 0.0;
const JOINT2_DEFAULT: f64 = 0.0;
const JOINT3_DEFAULT: f64 = 0.0;
const JOINT4_DEFAULT: f64 = 0.0;
const JOINT5_DEFAULT: f64 = 0.0;
const JOINT6_DEFAULT: f64 = 0.0;


struct App {
    joint1: f64,
    joint2: f64,
    joint3: f64,
    joint4: f64,
    joint5: f64,
    joint6: f64,

}

#[derive(Debug)]
enum Msg {
    Joint1Slider(f64),
    Joint2Slider(f64), 
    Joint3Slider(f64),
    Joint4Slider(f64), 
    Joint5Slider(f64), 
    Joint6Slider(f64),
    Reset,
}

#[relm4::component]
impl SimpleComponent for App {
    type Init = ();
    type Input = Msg;
    type Output = ();

    view! {
        gtk::Window {
            set_title: Some("Slider Reset Example"),
            set_default_size: (300, 100),

            gtk::Box {
                set_orientation: gtk::Orientation::Vertical,
                set_spacing: 12,
                set_margin_all: 12,

                #[name(slider1)]
                gtk::Scale {
                    set_orientation: gtk::Orientation::Horizontal,
                    set_range: (-180.0, 180.0),
                    set_draw_value: true,
                    

                    #[watch]
                    set_value: model.joint1,

                    connect_value_changed[sender] => move |scale| {
                        sender.input(Msg::Joint1Slider(scale.value()));
                    }
                },

                #[name(slider2)]
                gtk::Scale {
                    set_orientation: gtk::Orientation::Horizontal,
                    set_range: (-180.0, 180.0),
                    set_draw_value: true,

                    #[watch]
                    set_value: model.joint2,

                    connect_value_changed[sender] => move |scale| {
                        sender.input(Msg::Joint2Slider(scale.value()));
                    }
                },


                #[name(slider3)]
                gtk::Scale {
                    set_orientation: gtk::Orientation::Horizontal,
                    set_range: (-180.0, 180.0),
                    set_draw_value: true,

                    #[watch]
                    set_value: model.joint3,

                    connect_value_changed[sender] => move |scale| {
                        sender.input(Msg::Joint3Slider(scale.value()));
                    }
                },


                #[name(slider4)]
                gtk::Scale {
                    set_orientation: gtk::Orientation::Horizontal,
                    set_range: (-180.0, 180.0),
                    set_draw_value: true,

                    #[watch]
                    set_value: model.joint4,

                    connect_value_changed[sender] => move |scale| {
                        sender.input(Msg::Joint4Slider(scale.value()));
                    }
                },


                #[name(slider5)]
                gtk::Scale {
                    set_orientation: gtk::Orientation::Horizontal,
                    set_range: (-180.0, 180.0),
                    set_draw_value: true,

                    #[watch]
                    set_value: model.joint5,

                    connect_value_changed[sender] => move |scale| {
                        sender.input(Msg::Joint5Slider(scale.value()));
                    }
                },


                #[name(slider6)]
                gtk::Scale {
                    set_orientation: gtk::Orientation::Horizontal,
                    set_range: (-180.0, 180.0),
                    set_draw_value: true,

                    #[watch]
                    set_value: model.joint6,

                    connect_value_changed[sender] => move |scale| {
                        sender.input(Msg::Joint6Slider(scale.value())); }
                },







                gtk::Button {
                    set_label: "Reset",

                    connect_clicked[sender] => move |_| {
                        sender.input(Msg::Reset);
                    }
                }
            }
        }
    }

    fn init(
        _: (),
        root: Self::Root,
        sender: ComponentSender<Self>,
    ) -> ComponentParts<Self> {
        let model = App {
            joint1: JOINT1_DEFAULT,
            joint2: JOINT2_DEFAULT,
            joint3: JOINT3_DEFAULT,
            joint4: JOINT4_DEFAULT,
            joint5: JOINT5_DEFAULT,
            joint6: JOINT6_DEFAULT,
        };

        let widgets = view_output!();

        ComponentParts {
            model,
            widgets,
        }
    }

    fn update(&mut self, msg: Msg, _: ComponentSender<Self>) {
    match msg {
        Msg::Joint1Slider(value) => self.joint1 = value,
        Msg::Joint2Slider(value) => self.joint2 = value,
        Msg::Joint3Slider(value) => self.joint3 = value,
        Msg::Joint4Slider(value) => self.joint4 = value,
        Msg::Joint5Slider(value) => self.joint5 = value,
        Msg::Joint6Slider(value) => self.joint6 = value,
        
        Msg::Reset => {
            self.joint1 = JOINT1_DEFAULT;
            self.joint2 = JOINT2_DEFAULT;
            self.joint3 = JOINT3_DEFAULT;
            self.joint4 = JOINT4_DEFAULT;
            self.joint5 = JOINT5_DEFAULT;
            self.joint6 = JOINT6_DEFAULT;

        }
    }
}
}

fn main() {
    let app = RelmApp::new("com.example.slider-reset");
    app.run::<App>(());
}
