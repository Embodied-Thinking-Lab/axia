#ifndef FORWARD_KINEMATICS_H
#define FORWARD_KINEMATICS_H
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    double x, y, z;
} Vector3;

// void free_matrix(matrix mat);
// void matrix_multiply(double *mat1, double *mat2, double *res16);
// void print_matrix(matrix mat);
// void compute_euler_angles(double rm[3][3], double euler_angles[3]);
// void compute_rotation(int type, double a, double mat[3][3]);
// void compute_rotation_matrix(double degZ, double degY, double degX, double z, double y, double x, double *res16);
void compute_DH_transform(double r, double alpha, double d, double theta, double *res_mat);
// void forward_kinematics(double joints[6], Vector3 *positions);
// void compute_TI(Vector3 TI_vector, double *res16);

void compute_FK_FFI(Vector3 *positions, Vector3 TI_vector, const double *dh_params, double *link_transforms, double *end_effector);
#endif
