import argparse


def challenge_1(file_path):
    # Solution in hours
    return 0


def challenge_2(file_path):
    # Remember! Solution in hours, and the same solution in days. Both ceiled to next integer
    # return toHours(solution), toDays(solution)
    return (0, 0)


def challenge_3(file_path):
    # No need a return
    return 0


def init(challenge=1, input='.'):
    challenge_fn = challenge_1 if challenge == 1 else challenge_2 if challenge == 2 else challenge_3
    return challenge_fn(input)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-C',
                        '--challenge',
                        type=int,
                        help='Number of challenge',
                        required=True,
                        choices=[x + 1 for x in range(3)])
    parser.add_argument(
        '--input',
        type=str,
        help='Input file name path',
        required=True,
    )

    # Structure:
    #   args.challenge: int (the number of challenge)
    #   args.input: str (the json input file path from here)
    args = parser.parse_args()
    init(args.challenge, args.input)
