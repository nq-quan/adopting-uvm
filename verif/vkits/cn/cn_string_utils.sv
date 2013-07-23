//-*- mode: Verilog; verilog-indent-level: 3; indent-tabs-mode: nil; tab-width: 1 -*-
// ***********************************************************************
// *
// * legal mumbo jumbo
// *
// *  (c) 2012, Cavi
// *                                                                     *
// ***********************************************************************
// * File        : cn_string_utils.sv
// * Author      : bdobbie
// * Description : common string manipilation utilities (split, joint, etc.)
// ***********************************************************************
`ifndef __CN_STRING_UTILS_SV__
 `define __CN_STRING_UTILS_SV__

//----------------------------------------------------------------------------
// func: split_string
//
// Generates a queue of strings ~_values~ that is the result of the string
// ~_str~ split based on the separator character ~_sep~.  If no separator is
// found in the string, the generated queue contains one element that is the
// string.  If the string is empty, then an empty queue is generated.
//
// Returns the size of the ~_values~ queue.
//
//----------------------------------------------------------------------------
function automatic int unsigned split_string (input string _str,
                                              input byte _sep,
                                              ref string _values[$]);
   int s = 0;
   int e = 0;
   _values.delete();
   while(e < _str.len()) begin
        for(s=e; e<_str.len(); ++e)
          if(_str[e] == _sep) break;
        if(s != e)
          _values.push_back(_str.substr(s,e-1));
        e++;
   end
   if (_values.size() == 0 && _str != "")
       _values.push_back(_str);
   return _values.size;
endfunction

//----------------------------------------------------------------------------
// func: join_string
//
// Returns a string that is the result joining all elements of a queue of
// strings ~_values~ with fields separated by the value of the separator string
// ~_sep~.
//
// ----------------------------------------------------------------------------
function automatic string join_string (ref string _values[$],
                                       input string _sep);
   string str = "";
   foreach (_values[i]) begin
        if (i==0)
          str = _values[0];
        else
          str = {str,_sep,_values[i]};
   end
   return str;
endfunction

`endif // __CN_STRING_UTILS_SV__