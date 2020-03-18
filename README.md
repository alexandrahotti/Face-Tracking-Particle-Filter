# Face Tracking using a Particle Filter with color based features
## Introduction
In this project, an algorithm for tracking faces between consecutive image sequences was implemented.

Face tracking over video frames is used within several different computer vision applications such as video games (Tung & Matsuyama, 2008), real-time surveillance (Segen, 1996) and applications for human-computer interaction to recognize facial expressions (Black & Jepson, 1998).

Currently, there are two popular approaches to solving this problem. One approach using the Mean Shift algorithm (Cheng, 1995) and another particle-based solution (Gordon et al., 1995).

In this project a particle filter based on color image features partially based on Nummiaro et al. (2003) was implemented. However, instead of including the window surrounding the face as part of the state, a self-updating tracking window was used in accordance with Wang et al. (2019).

## Approach
First, the Viola-Jones object detection framework proposed
by Viola et al. (2001) was used to detect the initial face
location. This position was then used as the belief of the
particle filter at the first time step. The Viola-Jones framework detects faces using Haar Features which rely on the
symmetry properties in human faces.

The tracking was achieved using a particle filter where the
object being tracked was believed to be at the weighted
mean location of these particles. Observations used to update weights were based on the colors of the areas surrounding the particle, as described by Nummiaro et al. (2003).

In order to transition to a new video frame, the particles
were propagated. Weights were subsequently updated by
measuring the similarities in color between neighborhoods
of the propagated particles and the object being tracked.
According to Nummiaro et al. (2003), there are numerous
benefits of tracing objects based on their coloring. Such as
computational efficiency and resilience against occlusion,
scale invariance and objects changing pose relative to the
camera, i.e. rotation.

However, unlike Nummiaro et al. (2003) the window enclosing the face was not included as part of the state. Thus, instead of propagating the individual particle bounding boxes
a self-updating tracking window as described by Wang et al.
(2019) was implemented. At each time step, the average
distance of all particles to the target center was computed.
This average distance was then compared between the current and the previous time step. When the average distance
increased the face was presumed to have moved towards the
camera and thus the scale of the bounding box increased.
According to Wang et al. (2019) this methodology improves
the tracking algorithms capability of adjusting the bounding
box when the size of the object being tracked substantially
changes between consecutive frames.



For more details see the project [report](https://github.com/alexandrahotti/Face-Tracking-Particle-Filter/blob/occlusion/Project_Report.pdf).

The matlab implementation can be found [here](https://github.com/alexandrahotti/Face-Tracking-Particle-Filter/tree/occlusion/Code).

## Results

### Vertical and Horizontal Motion
<p align="center">
<img src="https://github.com/alexandrahotti/Face-Tracking-Particle-Filter/blob/occlusion/output_videos/gifs/up_and_down_movement.gif" width = "60%"/>
</p>

### Occlusion and Uneven Lighting

<p align="center">
<img src="https://github.com/alexandrahotti/Face-Tracking-Particle-Filter/blob/occlusion/output_videos/gifs/occlusion.gif" width = "60%"/>
</p>


### Fast Motion and Uneven Lighting
<p align="center">
<img src="https://github.com/alexandrahotti/Face-Tracking-Particle-Filter/blob/occlusion/output_videos/gifs/fast-movement-blue-background.gif" width = "60%"/>
</p>

### Size Change and Uneven Lighting
<p align="center">
<img src="https://github.com/alexandrahotti/Face-Tracking-Particle-Filter/blob/occlusion/output_videos/gifs/size-change-blue-background%20(1).gif" width = "60%"/>
</p>

## References
Nummiaro, K., Koller-Meier, E., and Van Gool, L. An
adaptive color-based particle filter. Image and vision
computing, 21(1):99–110, 2003.

Viola, P., Jones, M., et al. Robust real-time object detection. International journal of computer vision, 4(34-47):
4, 2001.

Wang, T., Wang, W., Liu, H., and Li, T. Research on a
face real-time tracking algorithm based on particle filter
multi-feature fusion. Sensors, 19(5):1245, 2019.



