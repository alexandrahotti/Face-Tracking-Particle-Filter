# Face Tracking using a Particle Filter with color based features
This project uses a color-based particle filter with a self-updating tracking window to trace faces in image sequences. This approach is mainly based on three previous studies.

Firstly, to find the initial face location for the particle face tracker the Viola-Jones object detection framework proposed by Viola et al. (2001) was used. This algorithm detects faces based on symmetry properties in human faces using so-called Haar Features.

The face tracking is achieved by using a color-based particle filter described by Nummiaro et al. (2003). The object tracking is achieved by propagating the particles and then measuring the color similarities between the object being tracked and the color in the neighborhoods of the propagated particles. According to Nummiaro et al. (2003), the benefits of using color for tracing objects is resilience against objects disappearing from the screen, i.e. occlusion, objects changing pose relative to the camera, i.e. rotation, scale invariance when the object being tracked changes size by moving closer or further away from the camera and lastly computational efficiency.

However, unlike Nummiaro et al. (2003) the window size
and scale of the face being tracked is not included in the
state, instead a self-updating tracking window as described
by Wang et al. (2019) was implemented. This approach
compares the average distance between particles and the
tracked object between the current and the previous time
step. When the average distance increases compared to the
previous time step the window size is increased and when
the average distance to the particle center decreases the
window is scaled down. According to Wang et al. (2019)
this approach improves the tracking algorithms abilities to
adjust the face window size when the size of the object
substantially changes throughout the video.

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



