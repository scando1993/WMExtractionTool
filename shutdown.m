function shutdown(varargin)
if nargin
   if isnumeric(varargin{1})
       if varargin{1} == -1
           evalc('!shutdown -a');
           return
       end
       t = ceil(varargin{1});
    else
       t = 60;
    end
else
   t = 60;
end
eval(['!shutdown -s -f -t ' num2str(t)])