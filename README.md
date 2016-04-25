# curedRone

This branch 'validation' is used to validate the written translational and attitude motion dynamics and kinematics with MATLAB Simulink 6DOF block. 
The codes written in MATLAB is compared to the Simulink 6DOF. In the code part, the numeric integration is written by hand, not done by simulink. The idea is to check if the equations are correct, numerical integration is correct and to be able to catch any bugs on coordinate transformations or God knows whatever else. 
The tricks gasped during this comparison is that the RK4 implementation of Simulink could be different than you expected. To be more clear, in the RK4 implementation, be sure that during the calculation of coefficients k1, k2, k3, k4; not only the states are evaluated differently but also the forces and moments. Although the forces and moments of t+1 are not available in a physical sense, since these values are available to the 6DOF block, it is by default interpolating this data values during the calculation of k2, k3, and k4 such that;
k1 = feval('model', x0, force_moment_i)
k2 = feval('model', x0 + 1/2 * h * k1, (force_moment_i + force_moment_i+1)/2)
k3 = feval('model', x0 + 1/2 * h * k2, (force_moment_i + force_moment_i+1)/2)
k4 = feval('model', x0 + h * k3, force_moment_i+2)

while what i was doing is, using force_moment_i for each of the coefficient calculation, since the data of force_moment(i+1) are not avaliable (since they are calculated depending on the states, the idea of using RK4 is to calculate x_i+1, 
force_moment_i+1 = func(x_i+1), there is no way to know force_moment_i+1 beforehand). 

The real case could be imitated by just calculating the forces and moments within the model, so for each feval operation, forces and moments could be evaluated with the iterated values of the states in each coefficient calculation k1, k2, k3, k4.
aim : This work is to code fault tolerant control algorithms to apply small UAS, preferably utilizing Paparazzi Autopilot System.

HOW TO:
1. run the configDrone.m file to have drone parameters in your workspace as global variables to enable access from inside the modelDrone.m file.
2. run simDrone.m
3. If you want to change aircraft parameters, change them from configDrone.m.
4. If you want to change simulation time, change sim_duration_min in simDrone.m

ASSUMPTIONS:
1. NED (North East Down) navigation frame is inertial where Newton's law apply.
2. Attitude sequence considered is Yaw-Pitch-Roll. And yes sequence matters! 

INFO FOR BEGINNERS:
1. Sequential Euler angle rotations relate the orientation of the aircrafts body-fixed frame to the navigation frame. For simulations quaternion preferred due to singularity issues of Euler angles.
It is proven that attitude representations will either have a redundant component (4 components) as in quaternions or singularity (Euler angles have 3 components resulting in singularity for pitch (theta) = 90 degrees - devision by 0).
quaternion representation used here has the scalar component as the first component:
q = q0 + q1 * i + q2 * j + q3 k

2.  w .:. angular velocity vector with components p, q, r
w = [p q r]'  in detail, w describes the angular motion of the body frame b with respect to navigation frame n (NED), expressed in body frame.

3. Attitude transformation matrix (Direction Cosine Matrix) is used to change the frame of interest that the vector or points expressed in. Lets say that we have a vector A fixed in inertial frame. Its representation in two frames will differ even it is the same vector. The frame to express it could be changed utilizing a direction cosine matrix. In this work, to express vectors in different frames is necessary which makes the use of DCM essential. 
C_n^b .:.transforms the vector A expressed in the navigation frame A^n into A^b, a vector expressed in the drone body-fixed frame. 
A^b = C_n^b * A^n    -----> in the code : c_n_to_b
Likewise a direction cosine matrix C_b^n, changes the representation of vector A expressed in drone body-fixed frame A^b, to a representation of the same vector A in navigation frame(NED) A^n.
A^n = C_b^n * A^b
And beware the relationship between these to transformation:
C_b^n = inverse(C_n^b) = transpose(C_n^b) 


