Column testing
==============

.. container:: column-left

   - This is
   - just to check
   - setting up columns

   .. code-block:: ql

      import cpp

      from 
      where
      select
   
.. container:: column-right

   - Item 1
   - Item 2
   - Item 3

   .. image:: _static-training/curiosity2.png
      :scale: 50 % 

Graph testing
==============

.. container:: column-left

   We frequently want to ask questions about the possible *order of execution* for a program.

   Example:

   .. code-block:: cpp

      if (x) {
        return 1;
      } else {
        return 2;
      }

   Possible execution order is usually represented by a *control flow graph*:
 
.. container:: column-right

   This CFG is generated from some text using a Sphinx extension.

   .. graphviz::
      
         digraph {
         graph [ dpi = 1000 ]
         node [shape=polygon,sides=4,color=blue4,style="filled,rounded",fontname=consolas,fontcolor=white]
         a [label=<if<BR /><FONT POINT-SIZE="10">IfStmt</FONT>>]
         b [label=<x<BR /><FONT POINT-SIZE="10">VariableAccess</FONT>>]
         c [label=<1<BR /><FONT POINT-SIZE="10">Literal</FONT>>]
         d [label=<2<BR /><FONT POINT-SIZE="10">Literal</FONT>>]
         e [label=<return<BR /><FONT POINT-SIZE="10">ReturnStmt</FONT>>]
         f [label=<return<BR /><FONT POINT-SIZE="10">ReturnStmt</FONT>>]

         a -> b
         b -> {c, d}
         c -> e
         d -> f

      }

Block diagram
=============

.. .. blockdiag::
..    
..     blockdiag {   
..       // node shapes for flowcharts
..       condition [shape = flowchart.condition];
..       database [shape = flowchart.database];
..       terminator [shape = flowchart.terminator];
..       input [shape = flowchart.input];
..         
..       condition -> database -> terminator -> input;
..     }

.. blockdiag::

   blockdiag {
     Query, Libraries -> "QL compiler" -> "Compiled query";
     Codebase -> Extractor -> "Snapshot database" -> Evaluator;
     "Compiled query" -> Evaluator -> "Query results";

     group { 
        label = "Query compilation";
        shape = line;
        Query; Libraries; "QL compiler"; "Compiled query";
     }

     group {
        label = "Extraction";
        shape = line;
        Codebase; Extractor; "Snapshot database";
     }

     group { 
        label = "Query evaluation";
        shape = "line";
        Evaluator;
     }
   }