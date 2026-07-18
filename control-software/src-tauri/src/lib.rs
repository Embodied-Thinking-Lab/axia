// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/

#[repr(C)]
#[derive(Debug, Clone, Copy, serde::Serialize, serde::Deserialize)]
pub struct Vector3 {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}

extern "C" {
    fn compute_FK_ffi(joints: *const f64, positions: *const Vector3, ti_vector: Vector3, out_matrix_16: *mut f64);
}

#[tauri::command]
async fn calculate_fk(joints: [f64; 6], positions: [Vector3; 7], ti_vector: Vector3) -> Result<[f64; 16], String> {
    let mut out_matrix = [0.0f64; 16];

    unsafe {
        compute_FK_ffi(joints.as_ptr(), positions.as_ptr(), ti_vector, out_matrix.as_mut_ptr());
    }

    Ok(out_matrix)
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
