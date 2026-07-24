#include "forward_kinematics.h"
#include <err.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif
#define DEG_TO_RAD(angle) ((angle) * M_PI / 180.0)

void mat4_mul(const double *m1, const double *m2, double *res_mat) {
	double temp[16];

	for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {

        	temp[i * 4 + j] = 0;

	         for (int k = 0; k < 4; k++) {
	             temp[i * 4 + j] += m1[i * 4 + k] * m2[k * 4 + j];
	         }
        }
    }

	memcpy(res_mat, temp, sizeof(temp));
}

void compute_euler_angles(double rm[3][3], double euler_angles[3]) {
    euler_angles[0] = atan2(rm[1][0], rm[0][0]);
    euler_angles[1] = atan2(-(rm[2][0]), sqrtf((rm[2][1] * rm[2][1]) + (rm[2][2] * rm[2][2])));
    euler_angles[2] = atan2(rm[2][1], rm[2][2]);
}

// type: 0=z(yaw), 1=y(pitch), 2=x(roll)
void compute_rotation(int type, double a, double mat[3][3]) {

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

void compute_rotation_matrix(double degZ, double degY, double degX, double z, double y, double x, double *res_mat) {
    double Z = DEG_TO_RAD(degZ);
    double Y = DEG_TO_RAD(degY);
    double X = DEG_TO_RAD(degX);

    res_mat[0 * 4 + 0] = cos(Z) * cos(Y);
    res_mat[0 * 4 + 1] = (cos(Z) * sin(Y) * sin(X)) - (sin(Z) * cos(X));
    res_mat[0 * 4 + 2] = (cos(Z) * sin(Y) * cos(X)) + (sin(Z) * sin(X));

    res_mat[1 * 4 + 0] = sin(Z) * cos(Y);
    res_mat[1 * 4 + 1] = (sin(Z) * sin(Y) * sin(X)) + (cos(Z) * cos(X));
    res_mat[1 * 4 + 2] = (sin(Z) * sin(Y) * cos(X)) - (cos(Z) * sin(X));

    res_mat[2 * 4 + 0] = -(sin(Y));
    res_mat[2 * 4 + 1] = cos(Y) * sin(X);
    res_mat[2 * 4 + 2] = cos(Y) * cos(X);

    res_mat[0 * 4 + 3] = x;
    res_mat[1 * 4 + 3] = y;
    res_mat[2 * 4 + 3] = z;

    res_mat[3 * 4 + 0] = 0;
    res_mat[3 * 4 + 1] = 0;
    res_mat[3 * 4 + 2] = 0;
    res_mat[3 * 4 + 3] = 1;

}

void compute_DH_transform(double r, double alpha, double d, double theta, double *res_mat) {
    res_mat[0] = cos(theta);
    res_mat[1] = -sin(theta) * cos(alpha);
    res_mat[2] = sin(theta) * sin(alpha);
    res_mat[3] = r * cos(theta);

    res_mat[4] = sin(theta);
    res_mat[5] = cos(theta) * cos(alpha);
    res_mat[6] = -cos(theta) * sin(alpha);
    res_mat[7] = r * sin(theta);

    res_mat[8] = 0;
    res_mat[9] = sin(alpha);
    res_mat[10] = cos(alpha);
    res_mat[11] = d;

    res_mat[12] = 0;
    res_mat[13] = 0;
    res_mat[14] = 0;
    res_mat[15] = 1;
}

void compute_FK(Vector3 positions[6], const double *dh_params, double *link_transforms, double res_mat[16]) {
    double current[16] = {
    	1, 0, 0, 0,
     	0, 1, 0, 0,
      	0, 0, 1, 0,
       	0, 0, 0, 1
    };

    for (int i=0; i<6; i++) {
    	double link[16];

     	compute_DH_transform(dh_params[i * 4 + 0], dh_params[i * 4 + 1], dh_params[i * 4 + 2], dh_params[i * 4 + 3], link);

      	double next[16];

       mat4_mul(current, link, next);

       memcpy(current, next, sizeof(current));

       memcpy(
           &link_transforms[i * 16],
           current,
           sizeof(double) * 16
       );

       if (positions != NULL) {
     		positions[i].x = current[3];
     		positions[i].y = current[7];
     		positions[i].z = current[11];
       }
    }

    memcpy(res_mat, current, sizeof(current));
}

void compute_TI(Vector3 TI_vector, double *res_mat) {
    compute_rotation_matrix(0, 0, 0, TI_vector.z, TI_vector.y, TI_vector.x, res_mat);
}

void compute_FK_FFI(Vector3 *positions, Vector3 TI_vector, const double *dh_params, double *link_transforms, double *end_effector) {
	double fk[16];
    double ti[16];

    compute_FK(positions, dh_params, link_transforms, fk);
    compute_TI(TI_vector, ti);
    mat4_mul(fk, ti, end_effector);
}
