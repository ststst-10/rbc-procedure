var C, K, A, N, R, w, Y, I, KoverN, logC, logK, logN, logw, logY, logI, logA;         // Declare endogenous variables: K/N aiuta nella scrittura dello steady-state model
varexo e;                                                                             // Declare exogenous variables

parameters alpha, beta, delta, rho, theta;                                            // Declare parameters

@#ifndef stoch_simul_periods                // if stoch_simul_periods is not defined at call, it is set = 0 (theoretical moments are calculated instead of simulated ones)
  @#define stoch_simul_periods = 0
@#endif

@#ifndef stoch_simul_order                  // if stoch_simul_order is not defined at call, the order is set = 2
  @#define stoch_simul_order = 2
@#endif

@#ifndef stoch_simul_hp                     // if stoch_simul_hp is not definef at call, it is set = 0 (no HP-filter applied on the simulated series)
  @#define stoch_simul_hp = 0
@#endif

@#ifndef smoothing                          // if smoothing is not defined at call, it is set to 1600 (for quarterly series)
  @#define smoothing = 1600
@#endif

alpha   = 0.36;         // From literature
beta    = 0.98;         // From literature
delta   = 0.02;         // From literature
rho     = rho_hat;      // Externally estimated (.mlx file)
theta   = 1.66;         // From literature
sigma   = sigma_hat;    // Externally estimated (.mlx file)            

model;
(1/C)   = beta*(1/C(+1))*(R(+1)+1-delta);                   // Euler equation
w       = (theta*C)/(1-N);                                  // Optimal labor supply
K       = I+(1-delta)*K(-1);                                // Law of motion for capital: K is K_{t+1}
log(A)  = rho*(log(A(-1)))+e;                               // Stochastic productivity process
Y       = A*(K(-1)^alpha)*(N^(1-alpha));                    // Production function
Y       = C+I;                                              // Aggregate resource constraint (Goods market clearing condition)
R       = alpha*A*(K(-1)^(alpha-1))*(N^(1-alpha));          // Optimal capital demand
w       = (1-alpha)*A*(K(-1)^(alpha))*(N^(-alpha));         // Optimal labor demand
KoverN  = K/N;
logC    = log(C);
logY    = log(Y);
logI    = log(I);
logN    = log(N);
logw    = log(w);
logA    = log(A);
logK    = log(K);
end;

steady_state_model;                                         // Steady stae analytical solutions: derived externally
A = 1;
KoverN = ((1-beta+beta*delta)/(beta*alpha))^(1/(alpha-1));
R = alpha*(KoverN)^(alpha-1);
w = (1-alpha)*(KoverN)^alpha;
N = (((1-alpha)/theta)*((KoverN)^alpha))/(((theta+1-alpha)/theta)*((KoverN)^alpha)-delta*(KoverN));
K = KoverN*N;
I = delta*K;
Y = A*(K^alpha)*(N^(1-alpha));
C = Y - I;
logC = log(C);
logY = log(Y);
logI = log(I);
logN = log(N);
logw = log(w);
logA = log(A);
logK = log(K);
end;

shocks;
var e; stderr sigma;        // Define the standard deviation for the productivity shocks (normal distribution with expected value 0 is assumed)                                
end;

@#if stoch_simul_hp         // if soch_simul_hp is activated HP-filtering option is passed                                                                                                 
  stoch_simul(order=@{stoch_simul_order}, nograph, ar=1, contemporaneous_correlation, hp_filter=@{smoothing}, periods=@{stoch_simul_periods});
@#else
  stoch_simul(order=@{stoch_simul_order}, nograph, ar=1, contemporaneous_correlation, periods=@{stoch_simul_periods});
@#endif