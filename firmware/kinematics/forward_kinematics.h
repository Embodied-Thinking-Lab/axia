#ifndef FORWARD_KINEMATICS_H
#define FORWARD_KINEMATICS_H
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int rows;
    int cols;
    double *m;
} matrix;

typedef struct {
    double x, y, z;
} Vector3;

matrix create_matrix(int rows, int cols);
void free_matrix(matrix mat);
matrix matrix_multiply(matrix mat1, matrix mat2);
void get_euler_angles(double rm[3][3], double euler_angles[3]);
void print_matrix(matrix mat);
void rotation(int type, double a, double mat[3][3]);
matrix rotation_matrix(double degZ, double degY, double degX, double z, double y, double x);
matrix get_link_matrix(double r, double alpha, double d, double theta);
// matrix forward_kinematics(double joints[6], Vector3 *positions);
matrix compute_TI(Vector3 TI_vector);
void compute_FK_ffi(Vector3 positions[7], Vector3 TI_vector, double DH_Param[6][4], double *out_matrix_16);

#endif
