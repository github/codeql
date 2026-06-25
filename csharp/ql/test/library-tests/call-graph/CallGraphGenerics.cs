namespace G
{
    namespace N1
    {
        class C1
        {
            public virtual void // $ TypeMention=System.Void
            M1<T1>(
                T1 x
            )
            { }

            public virtual void // $ TypeMention=System.Void
            M2<T1, T2>(
                T1 x1, T2 x2
            )
            { }

            void M() // $ TypeMention=System.Void
            {
                this.M1(0); // $ StaticTarget=G.N1.C1.M1`1
                this.M2(0, ""); // $ StaticTarget=G.N1.C1.M2`2
            }
        } // $ Class=G.N1.C1

        class C2 : C1 // $ TypeMention=G.N1.C1
        {
            public override void // $ TypeMention=System.Void
            M1<S1>(
                S1 x
            )
            { }

            public override void // $ TypeMention=System.Void
            M2<S1, S2>(
                S1 x1, S2 x2
            )
            { }

            void M() // $ TypeMention=System.Void
            {
                this.M1(0); // $ StaticTarget=G.N1.C2.M1`1
                this.M2(0, ""); // $ StaticTarget=G.N1.C2.M2`2
            }
        } // $ Class=G.N1.C2
    }
}