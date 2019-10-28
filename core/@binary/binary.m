classdef binary
   properties
       length;
       mass; 
       moi;
   end
   methods
      function obj = link(length, mass, moi)
         if nargin > 0
            obj.length = length;
            obj.mass=mass;
            obj.moi=moi;
         end
      end
   end
end