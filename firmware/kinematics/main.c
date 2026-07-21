#include "forward_kinematics.h"
#include <stdio.h>

int main() {

    double joints[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    Vector3 positions[7] = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
    Vector3 ti_vector = {0, 0, 90};
    double out_matrix_16[16];
    compute_FK_ffi(joints, positions, ti_vector, out_matrix_16);

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%f ", out_matrix_16[i * 4 + j]);
        }
        printf("\n");
    }

    return 0;
}
