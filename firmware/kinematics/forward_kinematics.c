#include "forward_kinematics.h"
#include <err.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif
#define DEG_TO_RAD(angle) ((angle) * M_PI / 180.0)

matrix create_matrix(int rows, int cols) {
    matrix mat;
    mat.rows = rows;
    mat.cols = cols;

    mat.m = (double *)calloc(rows * cols, sizeof(double));
    return mat;
}

void free_matrix(matrix mat) {
    free(mat.m);
}

matrix matrix_multiply(matrix mat1, matrix mat2) {

    if (mat1.cols != mat2.rows) {
        errx(EXIT_FAILURE, "Need matrix of same size for matrix_multiply");
    }

    matrix res = create_matrix(mat1.cols, mat2.rows);

    for (int i = 0; i < mat1.rows; i++) {
        for (int j = 0; j < mat2.cols; j++) {
            double sum = 0.0;
            for (int k = 0; k < mat1.cols; k++) {
                sum += mat1.m[i * mat1.cols + k] * mat2.m[k * mat2.cols + j];
            }
            res.m[i * res.cols + j] = sum;
        }
    }

    return res;
}

void get_euler_angles(double rm[3][3], double euler_angles[3]) {
    euler_angles[0] = atan2(rm[1][0], rm[0][0]);
    euler_angles[1] = atan2(-(rm[2][0]), sqrtf((rm[2][1] * rm[2][1]) + (rm[2][2] * rm[2][2])));
    euler_angles[2] = atan2(rm[2][1], rm[2][2]);
}

void print_matrix(matrix mat) {
    for (int i = 0; i < mat.cols; i++) {
        for (int j = 0; j < mat.rows; j++) {
            printf("%.5f ", mat.m[i * mat.cols + j]);
        }
        printf("\n");
    }

    printf("\n");
}

// type: 0=z(yaw), 1=y(pitch), 2=x(roll)
// a: angle
void rotation(int type, double a, double mat[3][3]) {

    // R_z(theta)
    switch (type) {
    case 0: // R_z
        mat[0][0] = cos(a);
        mat[0][1] = -sin(a);
        mat[0][2] = 0;
        mat[1][0] = sin(a);
        mat[1][1] = cos(a);
        mat[1][2] = 0;
        mat[2][0] = 0;
        mat[2][1] = 0;
        mat[2][2] = 1;
        break;
    case 1: // R_y
        mat[0][0] = cos(a);
        mat[0][1] = 0;
        mat[0][2] = sin(a);
        mat[1][0] = 0;
        mat[1][1] = 1;
        mat[1][2] = 0;
        mat[2][0] = -sin(a);
        mat[2][1] = 0;
        mat[2][2] = cos(a);
        break;
    case 2: // R_x
        mat[0][0] = 1;
        mat[0][1] = 0;
        mat[0][2] = 0;
        mat[1][0] = 0;
        mat[1][1] = cos(a);
        mat[1][2] = -sin(a);
        mat[2][0] = 0;
        mat[2][1] = sin(a);
        mat[2][2] = cos(a);
        break;
    default:
        break;
    }
}

matrix rotation_matrix(double degZ, double degY, double degX, double z, double y, double x) {
    double Z = DEG_TO_RAD(degZ);
    double Y = DEG_TO_RAD(degY);
    double X = DEG_TO_RAD(degX);
    // printf("Z: %.5f, Y: %.5f, X: %.5f\n", Z, Y, X);

    matrix res = create_matrix(4, 4);
    if (res.m == NULL) {
        return res;
    }

    res.m[0 * res.cols + 0] = cos(Z) * cos(Y);
    res.m[0 * res.cols + 1] = (cos(Z) * sin(Y) * sin(X)) - (sin(Z) * cos(X));
    res.m[0 * res.cols + 2] = (cos(Z) * sin(Y) * cos(X)) + (sin(Z) * sin(X));
    res.m[1 * res.cols + 0] = sin(Z) * cos(Y);
    res.m[1 * res.cols + 1] = (sin(Z) * sin(Y) * sin(X)) + (cos(Z) * cos(X));
    res.m[1 * res.cols + 2] = (sin(Z) * sin(Y) * cos(X)) - (cos(Z) * sin(X));
    res.m[2 * res.cols + 0] = -(sin(Y));
    res.m[2 * res.cols + 1] = cos(Y) * sin(X);
    res.m[2 * res.cols + 2] = cos(Y) * cos(X);
    res.m[0 * res.cols + 3] = x;
    res.m[1 * res.cols + 3] = y;
    res.m[2 * res.cols + 3] = z;
    res.m[3 * res.cols + 0] = 0;
    res.m[3 * res.cols + 1] = 0;
    res.m[3 * res.cols + 2] = 0;
    res.m[3 * res.cols + 3] = 1;

    return res;
}

matrix get_link_matrix(double r, double alpha, double d, double theta) {

    matrix res = create_matrix(4, 4);
    if (res.m == NULL) {
        return res;
    }

    res.m[0 * res.cols + 0] = cos(theta);
    res.m[0 * res.cols + 1] = -sin(theta) * cos(alpha);
    res.m[0 * res.cols + 2] = sin(theta) * sin(alpha);
    res.m[0 * res.cols + 3] = r * cos(theta);

    res.m[1 * res.cols + 0] = sin(theta);
    res.m[1 * res.cols + 1] = cos(theta) * cos(alpha);
    res.m[1 * res.cols + 2] = -cos(theta) * sin(alpha);
    res.m[1 * res.cols + 3] = r * sin(theta);

    res.m[2 * res.cols + 0] = 0;
    res.m[2 * res.cols + 1] = sin(alpha);
    res.m[2 * res.cols + 2] = cos(alpha);
    res.m[2 * res.cols + 3] = d;

    res.m[3 * res.cols + 0] = 0;
    res.m[3 * res.cols + 1] = 0;
    res.m[3 * res.cols + 2] = 0;
    res.m[3 * res.cols + 3] = 1;

    return res;
}

matrix forward_kinematics(Vector3 *positions, double DH_PARAM[6][4]) {

    //     double DH_PARAM[6][4] = {
    //         // 	 r,   alpha, 	        d,     theta
    //         {0, DEG_TO_RAD(0), 87, DEG_TO_RAD(joints[0])},
    //         {0, DEG_TO_RAD(90), 97, DEG_TO_RAD(joints[1])},
    //         {280, DEG_TO_RAD(0), 0, DEG_TO_RAD(joints[2] + 90)},
    //         {0, DEG_TO_RAD(-90), 25.5, DEG_TO_RAD(joints[3])},
    //         {0, DEG_TO_RAD(-90), 220.5, DEG_TO_RAD(joints[4])},
    //         {0, DEG_TO_RAD(90), 70, DEG_TO_RAD(joints[5] - 90)}};

    matrix T_links[6];
    for (int i = 0; i < 6; i++) {
        T_links[i] = get_link_matrix(DH_PARAM[i][0], DH_PARAM[i][1], DH_PARAM[i][2], DH_PARAM[i][3]);
    }

    if (positions != NULL) {
        positions[0] = (Vector3){0.0f, 0.0f, 0.0f};
    }

    matrix T_cum[6];

    T_cum[0] = T_links[0];

    for (int i = 1; i < 6; i++) {
        T_cum[i] = matrix_multiply(T_cum[i - 1], T_links[i]);
    }

    if (positions != NULL) {
        for (int i = 1; i < 6; i++) {
            positions[i].x = (float)T_cum[i].m[0 * T_cum[i].cols + 3];
            positions[i].y = (float)T_cum[i].m[1 * T_cum[i].cols + 3];
            positions[i].z = (float)T_cum[i].m[2 * T_cum[i].cols + 3];
        }
    }

    matrix T_final = T_cum[5];

    // for (int i = 0; i < 6; i++) {
    //     printf("matrix, %d\n", i + 1);
    //     print_matrix(T_cum[i]);
    // }
    // printf("matrix, %d\n", 7);
    // print_matrix(T_final);

    for (int i = 0; i < 5; i++) {
        free(T_cum[i].m);
    }

    for (int i = 1; i < 6; i++) {
        free(T_links[i].m);
    }

    return T_final;
}

matrix compute_TI(Vector3 TI_vector) {
    matrix tool_interface = rotation_matrix(0, 0, 0, TI_vector.z, TI_vector.y, TI_vector.x);
    return tool_interface;
}

void compute_FK_ffi(Vector3 positions[7], Vector3 TI_vector, double DH_Param[6][4], double *out_matrix_16) {

    matrix tool_interface = compute_TI(TI_vector);
    matrix mat = forward_kinematics(positions, DH_Param);
    matrix end_effector = matrix_multiply(mat, tool_interface);

    if (end_effector.m != NULL && out_matrix_16 != NULL) {
        for (int i = 0; i < 16; i++) {
            out_matrix_16[i] = end_effector.m[i];
        }
    }

    free_matrix(tool_interface);
    free_matrix(mat);
    free_matrix(end_effector);
}
