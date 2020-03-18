# Face Tracking using a Particle Filter with color based features
## Introduction
In this project, an algorithm for tracking faces between consecutive image sequences was implemented.

Face tracking over video frames is used within several different computer vision applications such as video games (Tung & Matsuyama, 2008), real-time surveillance (Segen, 1996) and applications for human-computer interaction to recognize facial expressions (Black & Jepson, 1998).

Currently, there are two popular approaches to solving this problem. One approach using the Mean Shift algorithm (Cheng, 1995) and another particle-based solution (Gordon et al., 1995).

In this project a particle filter based on color image features partially based on Nummiaro et al. (2003) was implemented. However, instead of including the window surrounding the face as part of the state, a self-updating tracking window was used in accordance with Wang et al. (2019).



## Problem Statement
The purpose of this project was to successfully implement a face tracking algorithm based on a color model. This algorithm had a self-updating tracking window as described by (Wang et al., 2019).

To qualitatively assess the rigor of the tracking algorithm, it was applied to video sequences under varying image conditions. Such conditions included even and uneven lighting as well as varying background colors. 

It was also qualitatively evaluated whether the tracking algorithm could withstand short term occlusion as well as a face moving at considerable speed. Lastly, an experiment was conducted to assess the self-updating tracking windows Wang et al. (2019) ability to handle scale changes.

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



