#include <err.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef M_PI
    #define M_PI 3.14159265358979323846
#endif
#define DEG_TO_RAD(a) ((a) * M_PI / 180.0)

int tool_z = DEG_TO_RAD(0);
int tool_y = DEG_TO_RAD(0);
int tool_x = DEG_TO_RAD(0);

// TODO: MAKE MATRIX STRUCT TO ALLOW FUNCTION MATRIX RETURN
typedef struct {
    int rows;
    int cols;
    double *m;
} matrix;

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


matrix rotation_matrix(double degZ, double degY, double degX) {
    double Z = DEG_TO_RAD(degZ);
    double Y = DEG_TO_RAD(degY);
    double X = DEG_TO_RAD(degX);
    printf("Z: %.5f, Y: %.5f, X: %.5f\n", Z, Y, X);

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
    res.m[0 * res.cols + 3] = tool_x;
    res.m[1 * res.cols + 3] = tool_y;
    res.m[2 * res.cols + 3] = tool_z;
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

matrix forward_kinematics(double J1, double J2, double J3, double J4, double J5, double J6) {

    double DH_PARAM[6][4] = {
        {0, DEG_TO_RAD(0), 87, DEG_TO_RAD(J1)},
        {0, DEG_TO_RAD(90), 97, DEG_TO_RAD(J2)},
        {280, DEG_TO_RAD(0), 0, DEG_TO_RAD(J3+90)},
        {0, DEG_TO_RAD(-90), 25.5, DEG_TO_RAD(J4+180)},
        {0, DEG_TO_RAD(90), 220.5, DEG_TO_RAD(J5+180)},
        {0, DEG_TO_RAD(-90), 70, DEG_TO_RAD(J6-90)}
    };

    matrix T0_1 = get_link_matrix(DH_PARAM[0][0], DH_PARAM[0][1], DH_PARAM[0][2], DH_PARAM[0][3]);
    matrix T1_2 = get_link_matrix(DH_PARAM[1][0], DH_PARAM[1][1], DH_PARAM[1][2], DH_PARAM[1][3]);
    matrix T2_3 = get_link_matrix(DH_PARAM[2][0], DH_PARAM[2][1], DH_PARAM[2][2], DH_PARAM[2][3]);
    matrix T3_4 = get_link_matrix(DH_PARAM[3][0], DH_PARAM[3][1], DH_PARAM[3][2], DH_PARAM[3][3]);
    matrix T4_5 = get_link_matrix(DH_PARAM[4][0], DH_PARAM[4][1], DH_PARAM[4][2], DH_PARAM[4][3]);
    matrix T5_6 = get_link_matrix(DH_PARAM[5][0], DH_PARAM[5][1], DH_PARAM[5][2], DH_PARAM[5][3]);
    printf("joint 1\n"); print_matrix(T0_1);
    printf("joint 2\n"); print_matrix(T1_2);
    printf("joint 3\n"); print_matrix(T2_3);
    printf("joint 4\n"); print_matrix(T3_4);
    printf("joint 5\n"); print_matrix(T4_5);
    printf("joint 6\n"); print_matrix(T5_6);

    matrix T = create_matrix(4, 4);
    if (T.m == NULL) {
        return T;
    }

    matrix temp1 = matrix_multiply(T0_1, T1_2);
    printf("first rotation from 1 to 2\n");
    print_matrix(temp1);
    matrix temp2 = matrix_multiply(temp1, T2_3);
    printf("first rotation from 3 to 4\n");
    print_matrix(temp1);
    matrix temp3 = matrix_multiply(temp2, T3_4);
    printf("first rotation from 4 to 5\n");
    print_matrix(temp1);
    matrix temp4 = matrix_multiply(temp3, T4_5);
    printf("first rotation from 5 to 6\n");
    print_matrix(temp1);
    T = matrix_multiply(temp4, T5_6);

    free(T0_1.m); free(T1_2.m); free(T2_3.m); free(T3_4.m); free(T4_5.m); free(T5_6.m);

    return T;
}

int main() {
    double R_z[3][3] = {0};
    double R_y[3][3] = {0};
    double R_x[3][3] = {0};

    rotation(0, 0, R_z);
    rotation(1, 0, R_y);
    rotation(2, 0, R_x);

    matrix tool_interface = rotation_matrix(0, 0, 0);
    print_matrix(tool_interface);

    matrix tool_frame = create_matrix(4, 4);
    tool_frame.m[0 * tool_frame.cols + 3] = tool_x;
    tool_frame.m[1 * tool_frame.cols + 3] = tool_z;
    tool_frame.m[2 * tool_frame.cols + 3] = tool_y;

    matrix mat = forward_kinematics(0, 0, 0, 0, 0, 0);
    print_matrix(mat);

    matrix end_affector = matrix_multiply(mat, tool_interface);
    printf("END AFFECTOR: \n"); print_matrix(end_affector);

    return 0;
}
