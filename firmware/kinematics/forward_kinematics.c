#include <err.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "forward_kinematics.h"
#include "raylib.h"

#ifndef M_PI
    #define M_PI 3.14159265358979323846
#endif
#define DEG_TO_RAD(a) ((a) * M_PI / 180.0)

double tool_z = DEG_TO_RAD(0);
double tool_y = DEG_TO_RAD(0);
double tool_x = DEG_TO_RAD(0);


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

matrix forward_kinematics(double J1, double J2, double J3, double J4, double J5, double J6, Vector3 *positions) {

    double DH_PARAM[6][4] = {
    // 	r,     alph, 	   d, 	   theta
        {0,   	DEG_TO_RAD(0),   87,    DEG_TO_RAD(J1)},
        {0,   	DEG_TO_RAD(0),  97,     	DEG_TO_RAD(J2+90)},
        {280, 	DEG_TO_RAD(90),   0,    DEG_TO_RAD(J3)},
        {0, 	DEG_TO_RAD(0),  25.5,   DEG_TO_RAD(J4-90)},
        {0,   	DEG_TO_RAD(0),  220.5,  	DEG_TO_RAD(J5-90)},
        {0,   	DEG_TO_RAD(-90),  70,   DEG_TO_RAD(J6+90)}
    };

    matrix T_links[6];
    for (int i=0; i<6; i++) {
    	T_links[i] = get_link_matrix(DH_PARAM[i][0], DH_PARAM[i][1], DH_PARAM[i][2], DH_PARAM[i][3]);
    }

    if (positions != NULL) {
    	positions[0] = (Vector3){0.0f, 0.0f, 0.0f};
    }

    matrix T_cum[6];

    T_cum[0] = T_links[0];

    for (int i=0; i<6; i++) {
    	T_cum[i] = matrix_multiply(T_cum[i-1], T_links[i]);
    }

    if (positions != NULL) {
    	for (int i=0; i<6; i++) {
   			positions[i+1].x = (float)T_cum[i].m[0 * T_cum[i].cols + 3];
    		positions[i+1].y = (float)T_cum[i].m[1 * T_cum[i].cols + 3];
     		positions[i+1].z = (float)T_cum[i].m[2 * T_cum[i].cols + 3];
     	}
    }

    matrix T_final = T_cum[5];


   	printf("X: %lf\n", T_final.m[0 * T_final.cols + 1]);
   	printf("Y: %lf\n", T_final.m[1 * T_final.cols + 1]);
   	printf("Z: %lf\n", T_final.m[2 * T_final.cols + 1]);


    for (int i=0; i<5; i++) {
    	free(T_cum[i].m);
    }

    for (int i = 1; i < 6; i++) {
        free(T_links[i].m);
    }

    return T_final;
}
