Currently, this is directed as communication to myself.

Solutions to the exercises of [erlang.org's course](https://www.erlang.org/course).

If you're learning Erlang, you probably should NOT read these solutions. It's better for you if you try to solve the exercises on your own.

**Development setup**: [Getting started with Erlang & Intellij](https://www.jetbrains.com/help/idea/getting-started-with-erlang.html).  
Currently not using `rebar(3)`. Tried it and doesn't seem as easy to start with as something like `npm`, and the exercises don't seem to need it.  
Also, this is not a repo to take good practices from :P. For example, one should never put test code in production code.

To myself: Next step is `Robustness and graphic bla bla`. Since `gs` has been removed in OTP 18.0, read this to start with wxwidgets: http://www.idiom.com/~turner/wxtut/wxwidgets.html

Stuff learnt or noted:

1) Google the "Selective Receive"; that's a behaviour I totally didn't expect from Erlang. The unmatched events actually remain in the queue!  
This is in contrast with some like Akka where you have `receive(Msg)` method and this gets all the messages and then they're popped immediately. Makes sense since there's no pre-matching on the message in Akka (at least, by default. You know, the guys of Akka like to make every known pattern part of the library -_- (or :), who knows)).

2) I didn't feel Erlang that different from MPI/C. Yes, they're absolutely different. But Erlang primitives for message passing, receive-on-blocking, and forking. But still, they both feel low level. Who else does? - MPI/C!  
I'm no expert on Erlang, but the other additions I can think of are queuing instead of block-on-send-or-receive & location transparency. Yes, I know that's huge, especially the first model-wise. But still, it feels too low-level for an actor model. As much as I initially dislike Akka, as much as I think the abstraction of a `class` with `receive(Msg)` is a much better abstraction for the actor model. In Erlang, I feel like I'm writing locks.  
Yes, that probably should change after learning stuff like `gen_server`, but still, hoped it'd have been at the language level since this is an Actor-Model language.  
Anyway, probably I don't wanna say that Erlang is like MPI/C, but I want to say that I was a tiny-tiny-bit disappointed in the language-level support for the Actor Model in Erlang.

3) Don't be tricked by Erlang taking the syntax of Prolog. This has nothing of the spirit of Prolog. It's like taking the syntax of Elm to make an imperative language xD.  
Erlang is not imperative, it's functional. But Prolog is a totally-different paradigm. Stuff like that happen. Probably Erlang author liked Prolog and liked Actor Model, mixed them, and in the process left out the gems of Prolog & took the normal. Not that he should have, it's just a note.

