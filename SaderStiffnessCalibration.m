function k = SaderStiffnessCalibration(Width, Length, NFreq, Qfact,rho,eta)    
% ########## Spring Constant Calibration Using Sader's Method ###########
% % input parameters
% Width of cantilever (micrometers)
% Legnth of cantilever (micrometers)
% Natural frequency (kHz)
% Quality factor
% density of medium (default. Air ), kg/m^3
% viscosity of medium (default. Air), kg/(m*s)
% ##################### Atitheb Chaiyasitdhi, KMUTT #####################
% ###################### Update: 02/02/2015  ############################
%
% This script is a MATLAB implementation of Sader's Mathematica scriptas 
% as provided in the Ref 3 #.
% 
% Ref 1 # Calibration of Rectangular Atomic Force Microscope Cantilevers, 
% John E. Sader, James W. M. Chon and Paul Mulvaney, Review of Scientific 
% Instruments, Vol. 70 (10), October 1999.
%
% Ref 2 # http://www.nanophys.kth.se/nanophys/facilities/nfl/afm/icon/...
% bruker-help/Content/Probe%20and%20Sample%20Guide/ThermalTune/Hydrody...
% namicModel.htm
%
% Ref 3 # http://www.ampc.ms.unimelb.edu.au/afm/mathematica.html

% #######################################################################
if nargin<=4
rho = 1.18; % density of medium (Ex. Air ), kg/m^3
eta = 1.86*10^(-5); % viscosity of medium (ex. Air), kg/(m*s)
% else
%     rho=varargin{1}; %#ok<*USENS>
%     eta=varargin{2};
end
rNFreq = 2*pi*NFreq*10^3; % raidial natural frequency, rad/s
Renolds = rho.*rNFreq.*((Width*10^-6).^2)./(4.*eta); % Renolds number

t = log10(Renolds);

% According to the correction function,

% ### Gamma_real(freq) = Omega(freq)*Gamma_complementary(freq) ###

% Omega(freq) is composed of a real part( Omega_real(freq) ) and an
% imaginary part ( Omega_imaginary(freq) ).

% #### Omega(freq) = Omega_real(freq) + i Omega_imaginary(freq) ###

% Omega_real(freq)
omega_real =...
(0.91324 - 0.48274.*t + 0.46842.*t.^2 - 0.12886.*t.^3 + 0.044055.*t.^4 -...
0.0035117.*t.^5 + 0.00069085.*t.^6)./(1 - 0.56964.*t + 0.48690.*t.^2 -...
0.13444.*t.^3 + 0.045155.*t.^4 - 0.0035862.*t.^5 + 0.00069085.*t.^6);

% Omega_imaginary(freq)
omega_imaginary =...
(-0.024134- 0.029256*t + 0.016294*t^2 - 0.00010961*t^3 +...
0.000064577*t^4 - 0.000044510*t^5)/(1 - 0.59702*t + 0.55182*t^2 -...
0.18357*t^3 + 0.079156*t^4 - 0.014369*t^5 + 0.0028361*t^6);
   
% Omega(freq)
omega = omega_real + 1i.*omega_imaginary;

% Gamma is the approximationg of the hydrodynamic function of a rectangular
% beam. It should be noted that the Gamma depends on only 1.) Renolds number
% and 2.) width of a rectangular beam (in this case, the AFM cantilever).

Gamma = omega*( 1 + (4.*1i.*besselk(1, -1i.*sqrt(1i.*Renolds)))./...
    (sqrt(1i*Renolds)*besselk(0, -1i.*sqrt(1i.*Renolds))) );
% # BesselK  is the modified Bessel function of the second kind 

% Spring Constant from Sader's method
k = 0.1906.*(rNFreq.^2).*rho.*(Width.^2).*Length*Qfact*imag(Gamma).*10^-18;
   
end