module CALC-SYNTAX
    import DOMAINS

    syntax Exp ::= Int | Id
            | "(" Exp ")"   [bracket]
            > left:
              Exp "/" Exp   [left, strict]
            | Exp "*" Exp   [left, strict]
            > left:
              Exp "-" Exp   [left, strict]
            | Exp "+" Exp   [left, strict]

    syntax Stmt ::= Id "=" Exp ";" [strict(2)]

    syntax Pgm ::= List{Stmt, ""}

    syntax KResult ::= Int
endmodule

module CALC
    import CALC-SYNTAX
    imports MAP

    configuration
    <T>
      <k> $PGM:Pgm </k>
      <vars> .Map </vars>
    </T>

    rule <k> D:Stmt P:Pgm => D ~> P ...</k>
    rule <k> .Pgm => . ...</k>

    // variable lookup
    rule <k> X:Id => I:Int ...</k>
       <vars>... X |-> I ...</vars>

    // decalaration + assignment
    rule <k> V:Id = I:Int ; => . ...</k>
       <vars> VARS => VARS [V <- I] </vars>

    rule I1:Int * I2:Int => I1 *Int I2
    rule I1:Int / I2:Int => I1 /Int I2
         requires I2 =/=Int 0
    rule I1:Int + I2:Int => I1 +Int I2
    rule I1:Int - I2:Int => I1 -Int I2
endmodule
