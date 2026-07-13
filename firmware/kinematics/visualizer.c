#include "raylib.h"
#include "forward_kinematics.h"
#include <err.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef M_PI
    #define M_PI 3.14159265358979323846
#endif
#define DEG_TO_RAD(a) ((a) * M_PI / 180.0)



void compute_fk(double joints[6], Vector3 points[7]) {
	double tool_z = DEG_TO_RAD(0);
	double tool_y = DEG_TO_RAD(0);
	double tool_x = DEG_TO_RAD(0);

    matrix tool_interface = rotation_matrix(0, 0, 0);

    matrix tool_frame = create_matrix(4, 4);

    if (tool_frame.m != NULL) {
    	tool_frame.m[0 * tool_frame.cols + 3] = tool_x;
        tool_frame.m[1 * tool_frame.cols + 3] = tool_z;
        tool_frame.m[2 * tool_frame.cols + 3] = tool_y;
    }

    matrix mat = forward_kinematics(joints, points);
    matrix end_effector = matrix_multiply(mat, tool_interface);

    free_matrix(tool_interface);
    free_matrix(tool_frame);
    free_matrix(mat);
    free_matrix(end_effector);
}

int main(void) {

    InitWindow(1080, 720, "Robot FK Visualizer");

    Camera3D camera = { 0 };
    camera.position = (Vector3) { 600.0f, 600.0f, 600.0f };
    camera.target = (Vector3) { 0.0f, 150.0f, 0.0f };
    camera.up = (Vector3) { 0.0f, 1.0f, 0.0f };
    camera.fovy = 45.0f;
    camera.projection = CAMERA_PERSPECTIVE;

    DisableCursor();

    double joint_angles[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    Vector3 link_positions[7];

    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        UpdateCamera(&camera, CAMERA_THIRD_PERSON);

        compute_fk(joint_angles, link_positions);

        BeginDrawing();
            ClearBackground(RAYWHITE);
            BeginMode3D(camera);

                DrawGrid(20, 50.0f);
                DrawSphere((Vector3){0, 0, 0}, 8.0f, BLACK);
                for(int i = 0; i < 6; i++) {
                    DrawLine3D(link_positions[i], link_positions[i+1], RED);
                    DrawSphere(link_positions[i], 6.0f, BLUE);
                }
                DrawSphere(link_positions[6], 8.0f, GREEN);

            EndMode3D();
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
