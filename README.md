# Capture Point Walking Robot

## Abstract 
Walking is such a mundane task for us that we do not even think about it when we are going from one place to another. However, once we start trying to make a humanoid robot do the same thing, we realize this is a very challenging task. So challenging that we still don't see any commercial humanoid anywhere today. Even the most advanced labs and groups in world struggled during the DARPA challenge 

![FallingRobots](/MediaFiles/FallingRobots.gif). 

But this is okay, researchers have kept on trying and we are getting better. Now there are some companies that are dedicated to humanoid robots. You probably all heard of Boston Dynamics. There are more key players out there hoping to make the world a better place: Rainbow (makes HUBO), Agility Robotics, Honda (makes ASIMO, I think they stopped though), Naver Labs (cool robot arms that are tendon-driven), Hyundai (mostly wearable robots), Hankook Mirae Technology (giant walking robot), and so on... 

## Introduction Linear Inverted Pendulum
When it comes to walking robots (at least in actual hardware robots and not simulation), almost all of them are based on trajectory from Linear Inverted Pendulum. This is a simple idea introduced by Kajita in 2001 [The 3D Linear Inverted Pendulum Mode: A simple modeling for a biped walking pattern generation](https://www.cs.cmu.edu/~hgeyer/Teaching/R16-899B/Papers/KajiitaEA01IEEE_ICIRS.pdf). The idea is to simplify the robot model all the way to an inverted pendulum with a point mass. And then go one step further and make the pendulum linear (always constant height). Now you have the linear inverted pendulum .Once you have the model (LIMP), play with it and find some nice initial conditions that gives you nice trajectories. In the end, you just want a trajectory based on the pendulum and you are going to feed it to the robot. 

![3DPendulum](/MediaFiles/3DPendulum.png) ![3DPendulum2](/MediaFiles/3DPendulum2.png)

Figure: LIPM

More on this can be found in my previous work with Sebastian in [LIPM in MATLAB and Simulink Robotics Arena](https://github.com/mathworks-robotics/msra-walking-robot/tree/master/LIPM). This mainly talks about the LIPM and kinematics of the robot (needed to translate the pendulum trajectory to something robot can understand: foot trajectory). 

![PendulumArc](/MediaFiles/PendulumArc.gif) 

Figure: Movement of the LIPM. 

## Capture Point Algorithm 
In this repository I try to explain a walking trajectory generator based on Capture Point. This is an algorithm described in Englsberger's [Bipedal walking control based on Capture Point Dynamics](https://ieeexplore.ieee.org/document/6094435) that uses the capture point concept to generate trajectory based on desired next plant foot position. You will see how easy it is to generate trajectory on the fly to make the robot go forwards, backwards, and sideways by whatever distance (of course within reasonable limits) with this algorithm. I consider this as the second key paper that is necessary for understanding walking robot (of course after Kajita's paper). This paper builds on the LIPM and Capture Point (independently introduced by [Pratt et al.](https://www.cs.cmu.edu/~cga/legs/Pratt_Goswami_Humanoids2006.pdf) and [Hof](https://pubmed.ncbi.nlm.nih.gov/17935808/)) for bipedal walking control. 

So what is a capture point? Capture point is "the point on the floor onto which the robot has to step to come to a complete rest"\[Englsberger\]. So for the given pendulum there is a capture point depending on its state (position and velocity), and if you place next base of the pendulum (also known as the zero moment point ZMP) the pendulum will come to a complete rest.   

![CapturePointStop](/MediaFiles/CapturePointStop.gif)

Figure: Pendulum coming to a complete rest after moving its base to the capture point. 

The explanation of the algorithm is explained with MATLAB livescript that contains visualizations to help readers understand. Then to illustrate the point that this algorithm can be used on an actual robot (which probably is used in many humanoid robots today), I fed the trajectory from algorithm to the robot in Simulink simulation. 

![DemoSimulation](/MediaFiles/DemoGIF.gif)

Figure: Controlling the robot 'real time' with Xbox Controller in Simulink 
