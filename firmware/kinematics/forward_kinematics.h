#ifndef FORWARD_KINEMATICS_H
#define FORWARD_KINEMATICS_H

#include <stdio.h>
#include <stdlib.h>
#include "raylib.h"

typedef struct {
    int rows;
    int cols;
    double *m;
} matrix;

// typedef struct {
// 	float x;
// 	float y;
// 	float z;
// } Vector3;

matrix create_matrix(int rows, int cols);
void free_matrix(matrix mat);
matrix matrix_multiply(matrix mat1, matrix mat2);
void get_euler_angles(double rm[3][3], double euler_angles[3]);
void print_matrix(matrix mat);
void rotation(int type, double a, double mat[3][3]);
matrix rotation_matrix(double degZ, double degY, double degX);
matrix get_link_matrix(double r, double alpha, double d, double theta);
matrix forward_kinematics(double J1, double J2, double J3, double J4, double J5, double J6, Vector3 *positions);

#endif
