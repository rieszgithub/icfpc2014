import sys

instructions = []
labels = {
    'kMapField':          0,
    'kLambdamanField':    1,
    'kGhostsField':       2,
    'kFruitsStatusField': 3,

    'kWallBlock': 0,
    'kEmptyBlock': 1,
    'kPillBlock': 2,
    'kPpillBlock': 3,
    'kFruitBlock': 4,
    'kLmStartBlock': 5,
    'kGhostStartBlock': 6,
    'kBlockWithGhost': 7,
    'kBlockWithEdibleGhost': 8,

    'kLmVitalityField':  0,
    'kLmLocationField':  1,
    'kLmDirectionField': 2,
    'kLmLivesField':     3,
    'kLmScoreField':     4,

    'kUp':    0,
    'kRight': 1,
    'kDown':  2,
    'kLeft':  3,

    'kPillScore': 10,
    'kPpillScore': 50,

    'kFruitWeight': 100,
    'kGhostWeight': 100,

    'kGhostRadar': 0, # 0 best!
    'kAvoidRadar': 2, # 1 best? 2 safe?
    'kSearchDepthWhenUnreachable': 10, # Grid 10 OK Streight 500 OK 750 NG
    'kSearchDepthWhenReachable': 10,
    'kAmbushLimit': 50,

    'kAAA': 1,
}

def getLoadInstruction(instructions, arg):
    if arg == 's':
        return True
    elif len(arg) >= 2 and arg[0] == 'e' and arg[1] in '0123456789':
        instructions.append(['LD', '0', arg[1:]])
        return True
    elif arg[0] == 'k':
        instructions.append(['LDC', str(labels[arg])])
        return True
    elif arg[0] in '0123456789':
        instructions.append(['LDC', arg])
        return True
    else:
        return False


def getStoreInstruction(instructions, arg):
    if arg == 's':
        pass
    elif arg[0] == 'e':
        instructions.append(['ST', '0', arg[1:]])
    else:
        raise Exception


def translate(instructions, ntpl):
    if len(ntpl) == 1:
        if getLoadInstruction(instructions, ntpl[0]):
            return

    if ntpl[0] == 'GOTO':
        instructions.append(['LDC', '0'])
        instructions.append(['ATOM'])
        instructions.append(['TSEL', ntpl[1], 'unreached'])
    elif ntpl[0] == 'ST' and len(ntpl) == 2 and ntpl[1][0] == 'e':
        instructions.append(['ST', '0', ntpl[1][1:]])
    elif ntpl[0] == 'LOG':
        instructions.append(['LDC', ntpl[1]])
        instructions.append(['DBUG'])
    elif ntpl[0] == 'INC' and len(ntpl) == 2:
        instructions.append(['LD', '0', ntpl[1][1:]])
        instructions.append(['LDC', '1'])
        instructions.append(['ADD'])
        instructions.append(['ST', '0', ntpl[1][1:]])
    elif ntpl[0] == 'DEC' and len(ntpl) == 2:
        instructions.append(['LD', '0', ntpl[1][1:]])
        instructions.append(['LDC', '1'])
        instructions.append(['SUB'])
        instructions.append(['ST', '0', ntpl[1][1:]])
    elif ntpl[0] == 'INC':
        instructions.append(['LD', ntpl[1], ntpl[2]])
        instructions.append(['LDC', '1'])
        instructions.append(['ADD'])
        instructions.append(['ST', ntpl[1], ntpl[2]])
    elif ntpl[0] == 'DEC':
        instructions.append(['LD', ntpl[1], ntpl[2]])
        instructions.append(['LDC', '1'])
        instructions.append(['SUB'])
        instructions.append(['ST', ntpl[1], ntpl[2]])
    elif (ntpl[0] in ['ADD', 'SUB', 'MUL', 'DIV',
                      'CAR', 'CDR', 'ATOM',
                      'DBUG'] and
          len(ntpl) == 2):
        getLoadInstruction(instructions, ntpl[1])
        instructions.append([ntpl[0]])
    elif (ntpl[0] in ['ADD', 'SUB', 'MUL', 'DIV'] and
          len(ntpl) == 3):
        getLoadInstruction(instructions, ntpl[1])
        getLoadInstruction(instructions, ntpl[2])
        instructions.append([ntpl[0]])
    elif ntpl[0] == 'MOD':
        getLoadInstruction(instructions, ntpl[1])
        getLoadInstruction(instructions, ntpl[1])
        getLoadInstruction(instructions, ntpl[2])
        instructions.append(['DIV'])
        getLoadInstruction(instructions, ntpl[2])
        instructions.append(['MUL'])
        instructions.append(['SUB'])
    elif ntpl[0] == 'RTN':
        argc = len(ntpl) - 1
        for i in xrange(argc):
            arg = str(ntpl[i + 1])
            getLoadInstruction(instructions, arg)
        instructions.append(['RTN'])
    elif ntpl[0] == 'CONS' and len(ntpl) == 3:
        getLoadInstruction(instructions, ntpl[1])
        getLoadInstruction(instructions, ntpl[2])
        instructions.append(['CONS'])
    elif ntpl[0] == 'POPFRONT':
        getLoadInstruction(instructions, ntpl[1])
        instructions.append(['CAR'])
        getLoadInstruction(instructions, ntpl[1])
        instructions.append(['CDR'])
        getStoreInstruction(instructions, ntpl[1])
    elif ntpl[0][0:3] == 'TIF':
        getLoadInstruction(instructions, ntpl[1])
        getLoadInstruction(instructions, ntpl[2])
        instructions.append(['C' + ntpl[0][3:]])
        instructions.append(['TSEL', ntpl[3], ntpl[4]])
    elif ntpl[0][-5:] == 'APPLY':
        argc = len(ntpl) - 2
        for i in xrange(argc):
            arg = str(ntpl[i + 2])
            getLoadInstruction(instructions, arg)
        getLoadInstruction(instructions, ntpl[1])
        instructions.append([ntpl[0][0:-5] + 'AP', str(argc)])
    elif ntpl[0][-4:] == 'CALL':
        argc = len(ntpl) - 2
        for i in xrange(argc):
            arg = str(ntpl[i + 2])
            getLoadInstruction(instructions, arg)
        instructions.append(['LDF', ntpl[1]])
        instructions.append([ntpl[0][0:-4] + 'AP', str(argc)])
    else:
        instructions.append(ntpl)


while True:
    l = sys.stdin.readline()
    if len(l) is 0:
        break
    l = l.split(';')[0].strip()
    if len(l) == 0:
        continue
    if l[len(l) - 1] == ':':
        label = l[0:len(l) - 1]
        labels[label] = len(instructions)
        continue
    tpl = l.split(' ')
    ntpl = []
    for t in tpl:
        if len(t) != 0:
            ntpl.append(t)

    for i in xrange(len(ntpl)):
        if ntpl[i] == '<-':
            translate(instructions, ntpl[i + 1:])
            for j in xrange(i - 1, -1, -1):
                getStoreInstruction(instructions, ntpl[j])
            break
    else:
        translate(instructions, ntpl)


for instruction in instructions:
    for i in xrange(len(instruction)):
        if instruction[i] in labels:
            instruction[i] = str(labels[instruction[i]])


for instruction in instructions:
    print ' '.join(instruction)


