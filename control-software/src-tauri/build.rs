fn main() {
    // tauri_build::build();

    
    cc::Build::new()
        .file("../../firmware/kinematics/forward_kinematics.c")
        .flag_if_supported("-Ofast")
        .compile("kinematics");

    println!("cargo:rerun-if-changed=../../firmware/kinematics/forward_kinematics.c");
    println!("cargo:rerun-if-changed=../../firmware/kinematics/forward_kinematics.h");
}
