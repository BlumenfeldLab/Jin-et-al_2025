function [microsaccades, msdx,msdy,stddev, maddev, v] = GetMicrosaccadesEK(EyeDeg, SAMPLING, VFAC, MINDUR)
%% INPUTS

%EyeDeg is 2xN long matrix of gaze location data (in degrees, Left and
%Right eye are input separately

%SAMPLING is the hertz of the data. Ex: 1000 for 1000Hz

%VFAC is the constant that will be multiplied against the E&K metric to
%form the microsaccade threshold (ellipse). Typically 3-5 (in the 2003
%paper E&K used 5), in the 2006 (E&M used 4). Lower = more sensitive

%MINDUR is the minimum duration of the microsaccade in INDICES, it's not
%milliseconds

%% OUTPUTS
% microsaccades: this the Nx7 structure described in the
% MicrosaccadeAnalysis2.m
% msdx = the E&K metrix for x dimension for this EYE / TRIAL
% msdy = the E&K metrix for x dimension for this EYE / TRIAL
% stddev = standard deviation of the EYE / TRIAL's velocity
% maddev = median absolute deviation of the EYE / TRIAL's velocity

% E&K algo detects ALL saccades, including large ones (> 1 deg)
% Microsaccade detection = Which data points exceed msdx * VFAC for more
% than MINDUR. (Of course msdy is also considered). 

EyeDeg = EyeDeg';
EyeDeg = [ones(size(EyeDeg,1),1) EyeDeg]; %quirk of microsacc_plugin format

N = length(EyeDeg);
v = zeros(N,3);

for k=1:N
    
    v(k,1)= EyeDeg(k,1);
    
end

%% Convert to velocity with a 6-sample smoothing
for k=2:N-1
    
    if k>=3 & k<=N-2 %same as Engbert/Kliegel
        v(k,2:3) = SAMPLING/6*[EyeDeg(k+2,2)+EyeDeg(k+1,2)-EyeDeg(k-1,2)-EyeDeg(k-2,2) EyeDeg(k+2,3)+EyeDeg(k+1,3)-EyeDeg(k-1,3)-EyeDeg(k-2,3)];
    end
end

% vel = sqrt(v(:,2).^2 + v(:,3).^2);

%% call Engbert/Kliegel algorithm 
[microsaccades,~,msdx,msdy,stddev,maddev] = microsacc_plugin(EyeDeg(:,2:3),v(:,2:3),VFAC,MINDUR);

end
