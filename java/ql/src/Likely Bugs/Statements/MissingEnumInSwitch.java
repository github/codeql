enum Answer { YES, NO, MAYBE }

class Optimist
{
	Answer interpret(Answer answer) {
		switch (answer) {
			case MAYBE:
				return Answer.YES;
			case NO:
				return Answer.MAYBE;
			// Missing case for 'YES'
		}
		throw new RuntimeException("uncaught case: " + answer);
	}
}
