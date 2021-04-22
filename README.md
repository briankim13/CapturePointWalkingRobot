# Capture Point Walking Robot

## Abstract 
Walking is such a mundane task for us that we do not even think about it when we are going from one place to another. However, once we start trying to make a humanoid robot do the same thing, we realize this is a very challenging task. So challenging that we still don't see any commercial humanoid anywhere today. Even the most advanced labs and groups in world struggled during the DARPA challenge 

![FallingRobots](/MediaFiles/FallingRobots.gif). 

But this is okay, researchers have kept on trying and we are getting better. There are labs working on humanoids, companies developing robots for commerical use, and research facilities that are keep pushing the boundary. So hopefully, one day, we can ask the robots to do the hard work for us. And for that I think we need more tutorials that can help students get started. This is just that. I try to provide a starting point (simplified and hopefully easy to understand) in this repository so that you can add fancier algorithms to it. 

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

```matlab
cpointx = xc + dxc/w; % xc: current x position, dxc: current x velocity
cpointy = yc + dyc/w; % yc: current y position, dyc: current y velocity 
```

![CapturePointStop](/MediaFiles/CapturePointStop.gif)

Figure: Pendulum coming to a complete rest after moving its base to the capture point. 

So how does capture point help us create a walking trajectory on the fly? This is where the capture point control law comes into play. For a given capture point (this describes the current state of the pendulum) and a desired capture point at the end of step (this describes where you want to put the next plant foot), you can find what the next ZMP (zero moment point, which is the base of the pendulum). 
```matlab 
function px = findZMP(w, dT, cpdesired, cpcurrent)
    b = exp(w*dT); 
    px = 1/(1-b)*cpdesired - b/(1-b)*cpcurrent; 
end
```

"So... What is the capture point, desired capture point, and ZMP?" So ZMP is where you want the base of the pendulum to be. You will be using this to generate the trajectory at each step. Current capture point is something that describes the current state (you can think of this as the observer state, in other words, this is just a different way of describing what position and velocity is). Desired capture point is where you want your next foot to be. 

"Aren't desired capture point and ZMP the same thing then?" Not quite. Desired capture point describes where the actual robot foot is going to be with an offset (in my example, there is no offset and desired capture point is where the actual foot it. In the paper, the foot is located at an offset of the capture point). The ZMP is the base of the pendulum that will be somewhere inside the boundary of the foot. So capture point is the actual foot location, and ZMP is the actual pendulum base location. They are close to each other but not quite the same. 

![CapturePointAndZMP](/MediaFiles/CapturePointAndZMP.png)

Figure: Red circle is ZMP and Blue rectangle is the desired capture point

Now the keys are all there. All we need to do to move the robot wherever we want is to come up with the desired foot positions (desired capture points) and calculate the ZMP based on the control law shown earlier. 

![CapturePointTrajectory](/MediaFiles/CPTrajectory.gif)

Figure: Trajectory based on LIPM using Capture Point control law to find next base 

Once this is done, we can automate the process a little bit by using Stateflow. Stateflow calculates the trajectory based on the input from the Xbox controller. 

![DemoSimulation](/MediaFiles/DemoGIF.gif)

Figure: Controlling the robot 'real time' with Xbox Controller in Simulink 
