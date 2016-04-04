# curedRone

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


