// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/

use std::sync::PoisonError;

#[repr(C)]
#[derive(Debug, Clone, Copy, serde::Serialize, serde::Deserialize)]
pub struct Vector3 {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}


extern "C" {
    fn compute_FK_FFI(
        positions: *mut Vector3,
        ti_vector: Vector3,
        dh_params: *const f64,
        link_transforms: *mut f64,
        end_effector: *mut f64,
    );
}

#[tauri::command]
async fn calculate_fk(
	mut positions: [Vector3; 7],
	dh_params: [[f64; 4]; 6],
	ti_vector: Vector3,
) -> Result<([Vector3; 7], [[f64; 16]; 6], [f64; 16]), String> {
	let mut link_transforms = [[0.0f64; 16]; 6];
    let mut end_effector = [0.0f64; 16];

    unsafe {
        compute_FK_FFI(
        	positions.as_mut_ptr(),
         	ti_vector,
          	dh_params.as_ptr() as *const f64,
          	link_transforms.as_ptr() as *mut f64,
          	end_effector.as_mut_ptr(),
        );
    }

    Ok((
  		positions,
    	link_transforms,
     	end_effector,
    ))
}

#[tauri::command]
fn set_joint(joint_id: u8, angle: f64) -> f64 {
    println!("Joint {} set to {}", joint_id, angle);
    angle
}


#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![set_joint, calculate_fk])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
