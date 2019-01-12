% Title: Ball and beam problem
%  Authors: Jonas Koenneman & Giovanni Licitra

options = OclOptions();
options.nlp.controlIntervals = 50;

sys = BallAndBeamSystem();
ocl = OclSolver(sys,BallAndBeamOCP,options);

 % bound on end time: 1 <= tf <= 5
ocl.setParameter('time', 1, 5); 

% set bounds for initial and endtime
ocl.setInitialBounds('r'      , -0.8);
ocl.setInitialBounds('dr'     , 0.3);
ocl.setInitialBounds('theta'  , deg2rad(5));
ocl.setInitialBounds('dtheta' , 0.0);

ocl.setEndBounds('r'      , 0);
ocl.setEndBounds('dr'     , 0);
ocl.setEndBounds('theta'  , 0);
ocl.setEndBounds('dtheta' , 0);

% Solve OCP
vars = ocl.getInitialGuess();
[vars,times] = ocl.solve(vars);

% Plot solution
figure;
subplot(3,1,1);hold on;grid on; 
plot(times.states.value,vars.states.r.value     ,'Color','b','LineWidth',1.5)
plot(times.states.value,vars.states.dr.value    ,'Color','r','LineWidth',1.5)
legend({'r [m]','dr [m/s]'})
plot(times.states.value, sys.r_b*ones(length(times)),'Color','b','LineWidth',1.0,'LineStyle','-.');
plot(times.states.value, sys.r_b*ones(length(times)),'Color','b','LineWidth',1.0,'LineStyle','-.');

subplot(3,1,2);hold on;grid on;
plot(times.states.value,rad2deg(vars.states.theta.value) ,'Color','b','LineWidth',1.5)
plot(times.states.value,rad2deg(vars.states.dtheta.value),'Color','r','LineWidth',1.5)
legend({'\theta [deg]','dtheta [deg/s]'})
plot(times.states.value, rad2deg(  sys.theta_b.*ones(length(times))),'Color','b','LineWidth',1.0,'LineStyle','-.');
plot(times.states.value, rad2deg( -sys.theta_b.*ones(length(times))),'Color','b','LineWidth',1.0,'LineStyle','-.');
plot(times.states.value, rad2deg( sys.dtheta_b.*ones(length(times))),'Color','r','LineWidth',1.0,'LineStyle','-.');
plot(times.states.value, rad2deg(-sys.dtheta_b.*ones(length(times))),'Color','r','LineWidth',1.0,'LineStyle','-.');

subplot(3,1,3);hold on;grid on;
stairs(times.controls.value,vars.controls.tau.value,'Color','g','LineWidth',1.5)
plot(times.states.value, sys.tau_b.*ones(length(times)),'Color','g','LineWidth',1.0,'LineStyle','-.');
plot(times.states.value,-sys.tau_b.*ones(length(times)),'Color','g','LineWidth',1.0,'LineStyle','-.');
legend({'\tau [Nm]'})
xlabel('time');

% Show Animation
animateBallAndBeam(times.states.value,vars.states.r.value,vars.states.theta.value);