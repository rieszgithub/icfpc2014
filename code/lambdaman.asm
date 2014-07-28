  ;DBUG e0
  ;DBUG e1

  ; initial state
  1
  0
  0
  0
  CONS
  CONS
  CONS

  LDF step
  CONS
  RTN


step:
  ;  e0 world
  ;  e1 map
  ;  e2 lmLocation
  ;  e3 up
  ;  e4 right
  ;  e5 down
  ;  e6 left
  ;  e7 lmDirection
  ;  e8 goIfNotWall result
  ;  e9 ghostsField
  ; e10 give up count
  ; e11 lmX
  ; e12 lmY
  ; e13 random calculation
  ; e14 new direction candidate
  ; e15 fruit status
  ;
  ; for map scanning
  ;
  ; e16 cursor x
  ; e17 cursor y
  ;
  ; e18 north
  ; e19 east
  ; e20 south
  ; e21 west
  ; e22 row
  ; e23 col
  ;
  ; e24 north BFS queue
  ; e25 east BFS queue
  ; e26 south BFS queue
  ; e27 west BFS queue
  ;
  ; e28 next to process
  ;
  ; e29 visited
  ;
  ; e30 block
  ;
  ; e31 should continue bfs
  ;
  ; e32 lambdaman status
  ;
  ; e33 shouldAimPill closure
  ;
  ; e34 blockCheck closure
  ;
  ; e35 mapAndCoordToBlock closure
  ;
  ; e36 next north BFS queue
  ; e37 next east BFS queue
  ; e38 next south BFS queue
  ; e39 next west BFS queue
  ;
  ; e40 distance
  ; e41 score weight
  ; e42 NOTUSED
  ; e43 NOTUSED
  ;
  ; e44 N best score
  ; e45 E
  ; e46 S
  ; e47 W
  ;
  ; e48 toScore closure
  ;
  ; e49 score of this block
  ;
  ; e50 accumulated score
  ;
  ; e51 map tree
  ;
  ; e52 map width
  ; e53 map height
  ;
  ; e54 best score
  ;
  ; e55 back direction
  ;
  ; e56 fruitScore
  ; e57 state
  ; e58 tick
  ;
  ; e59 bfs backward
  ;
  ; e60 seen ghost
  ;
  ; e61 kill
  ;
  ; e62 ppill path
  ;
  ; e63 ambush count
  e0 <- CALL mystep e1 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 e0 0 0 0 0 0 0

  DBUG e0

  RTN e0


addMod4:
  e0 <- ADD e0 e1
  MOD e0 4
  RTN


indexer:
  TIFEQ e1 0 reachedIndex notReachedIndex
  reachedIndex:
    ATOM e0
    TSEL indexerIsTail indexerIsNotTail
    indexerIsTail:
      RTN e0
    indexerIsNotTail:
      CAR e0
      RTN

  notReachedIndex:
    CDR e0
    SUB e1 1

    TCALL indexer s s


tickerIncrease:
  TIFEQ e0 kPillBlock tickerPill tickerNotPill
  tickerPill:
    RTN 137
  tickerNotPill:

  TIFEQ e0 kPpillBlock tickerPpill tickerNotPpill
  tickerPpill:
    RTN 137
  tickerNotPpill:

  TIFEQ e0 kFruitBlock tickerFruit tickerNotFruit
  tickerFruit:
  LD 2 15
  TIFEQ s 0 tickerFruitNotPresent tickerFruitPresent
  tickerFruitPresent:
    RTN 137
  tickerFruitNotPresent:
  tickerNotFruit:

  RTN 127


killCount:
  ATOM e0 ; kGhostsFiled
  TSEL killListNotFound killListFound
  killListNotFound:
    RTN e3
  killListFound:
    CAR e0 ; ghost entry
    CDR
    CAR ; location
    CAR ; x

    TIFEQ s e1 killXMatchSuccess killXMatchFail
    killXMatchFail:
      CDR e0
      e1
      e2
      e3
      e4
      TCALL killCount s s s s s
    killXMatchSuccess:
      CAR e0 ; ghost entry
      CDR
      CAR ; location
      CDR ; y

      TIFEQ s e2 killYMatchSuccess killYMatchFail
      killYMatchFail:
        CDR e0
        e1
        e2
        e3
        e4
        TCALL killCount s s s s s
      killYMatchSuccess:
        CDR e0
        e1
        e2
        e3
        CAR e0
        CAR
        1
        CEQ
        ADD
        e4
        ADD
        0
        CGT
        e4
        TCALL killCount s s s s s


ticker:
  LD 1 57
  CAR ; random

  TIFEQ e0 kUp tickerUp tickerNotUp
  tickerUp:
    LD 1 58 ; tick
    LD 1 3 ; up
    CALL tickerIncrease s
    ADD

    LD 1 61 ; kill
    LD 1 9
    LD 1 11
    LD 1 12
    SUB 1
    CALL killCount s s s 0 0
    ADD

    LD 1 63

    CONS
    CONS
    CONS

    e0 ; result
    CONS

    RTN
  tickerNotUp:

  TIFEQ e0 kRight tickerRight tickerNotRight
  tickerRight:
    LD 1 58 ; tick
    LD 1 4 ; down
    CALL tickerIncrease s
    ADD

    LD 1 61 ; kill
    LD 1 9
    LD 1 11
    ADD 1
    LD 1 12
    CALL killCount s s s 0 0
    ADD

    LD 1 63

    CONS
    CONS
    CONS

    e0 ; result
    CONS

    RTN
  tickerNotRight:

  TIFEQ e0 kDown tickerDown tickerNotDown
  tickerDown:
    LD 1 58 ; tick
    LD 1 5
    CALL tickerIncrease s
    ADD

    LD 1 61; kill
    LD 1 9
    LD 1 11
    LD 1 12
    ADD 1
    CALL killCount s s s 0 0
    ADD

    LD 1 63

    CONS
    CONS
    CONS

    e0 ; result
    CONS

    RTN
  tickerNotDown:

  TIFEQ e0 kLeft tickerLeft tickerNotLeft
  tickerLeft:
    LD 1 58 ; tick
    LD 1 6
    CALL tickerIncrease s
    ADD

    LD 1 61 ; kill
    LD 1 9
    LD 1 11
    SUB 1
    LD 1 12
    CALL killCount s s s 0 0
    ADD

    LD 1 63

    CONS
    CONS
    CONS

    e0 ; result
    CONS

    RTN
  tickerNotLeft:
    STOP


treeInsert:
  ATOM e0 ; tree
  TSEL treeZeroNotCreated treeZeroCreated
  treeZeroNotCreated:
    0
    CONS 0 0
    e0 <- CONS
  treeZeroCreated:

  e1 ; current key
  0
  CEQ
  TSEL treeInsertZero treeInsertNonZero
  treeInsertZero:
    e2 ; value
    CDR e0
    CONS
    RTN
  treeInsertNonZero:
    MOD e1 2
    TSEL treeInsertOdd treeInsertEven
    treeInsertEven:
      CAR e0

      CDR e0
      CAR
      DIV e1 2 ; next key
      CALL treeInsert s s e2

      CDR e0
      CDR

      CONS

      CONS

      RTN
    treeInsertOdd:
      CAR e0

      CDR e0
      CAR

      CDR e0
      CDR
      DIV e1 2 ; next key
      CALL treeInsert s s e2

      CONS

      CONS

      RTN


treeFind:
  e1
  0
  CEQ
  TSEL lookZero lookNonZero
  lookZero:
    CAR e0
    RTN
  lookNonZero:
    MOD e1 2
    TSEL lookOdd lookEven
    lookEven:
      CDR e0
      CAR
      DIV e1 2
      TCALL treeFind s s
    lookOdd:
      CDR e0
      CDR
      DIV e1 2
      TCALL treeFind s s


shouldAimPill:
  e2 <- LD 1 11
  e3 <- LD 1 12

  shouldAimPillLoop:

  e2
  e3
  e0
  e1
  e2 e3 <- CALL addVector2D s s s s

  e2
  e3
  0
  0
  LD 1 35
  e4 <- APPLY s s s s s ; mapAndCoordToBlock

  ;DBUG e4

  CALL isPillOrPpill e4
  TSEL seePillOrPpill doNotSeePillOrPpill
  seePillOrPpill:
    e2 e3 <- CALL addVector2D e2 e3 e0 e1

    e2
    e3
    0
    0
    LD 1 35
    e4 <- APPLY s s s s s ; mapAndCoordToBlock

    TIFEQ e4 kBlockWithGhost foundGhostBeyond didNotFindGhostBeyond
    foundGhostBeyond:
      RTN 0
    didNotFindGhostBeyond:
      RTN 1

  doNotSeePillOrPpill:

  CALL isWallOrGhost e4
  TSEL shouldAimPillLoopExit shouldAimPillLoop
  shouldAimPillLoopExit:
    RTN 0


mapAndCoordToBlock:
  e0
  e1
  LD 1 9 ; ghostField
  e2 <- CALL getGhost s s s
  ATOM e2
  TSEL blockIsNotGhost blockIsGhost
  blockIsGhost:
    TIFEQ e3 kAAA considerGhostBePill notEnforcedConsider
    notEnforcedConsider:

    LD 1 32 ; lmVitality
    TIFGTE s 254 considerGhostBePill doNotConsiderGhostBePill
    considerGhostBePill:
      CAR e2
      TIFEQ s 2 blockIsNotGhost ghostIsNotInvisible
      ghostIsNotInvisible:

      RTN kBlockWithEdibleGhost
    doNotConsiderGhostBePill:
      RTN kBlockWithGhost

  blockIsNotGhost:
    LD 1 1 ; map
    CALL indexer s e1
    e2 <- CALL indexer s e0

    ;LD 1 51
    ;LD 1 52 ; width
    ;MUL e1 ; y * width
    ;ADD e0 ; y * width + x = block id
    ;e2 <- CALL treeFind s s

    RTN e2


blockCheck:
  LD 1 16
  LD 1 17
  LD 1 9
  e1 <- CALL getGhost s s s
  ATOM e1
  TSEL blockCheckIsNotGhost blockCheckIsGhost
  blockCheckIsGhost:
    LD 1 32 ; lmVitality
    TIFGT s 0 bCconsiderGhostBePill bCdoNotConsiderGhostBePill
    bCconsiderGhostBePill:
      CAR e1
      TIFEQ s 2 blockCheckIsNotGhost bCghostIsNotInvisible
      bCghostIsNotInvisible:

      RTN kBlockWithEdibleGhost
    bCdoNotConsiderGhostBePill:
      RTN kBlockWithGhost

  blockCheckIsNotGhost:
    LD 1 15
    TIFEQ s 0 bCnoFruit bCfruitAlive
    bCfruitAlive:
      TIFEQ e0 kFruitBlock bCisFruit bCisNotFruit
      bCisFruit:
        RTN kFruitBlock
      bCisNotFruit:

    bCnoFruit:

    RTN e0


getAdjustedScore:
  TIFEQ e0 0 noAdjust doAdjust
  noAdjust:
    RTN 0
  doAdjust:

  e0 <- MUL e0 e1 ; score * weight
  TIFEQ e0 0 avoidZero noAvoidZero
  avoidZero:
    RTN 1
  noAvoidZero:
    RTN e0


toScore:
  e0
  kPillBlock
  CEQ
  MUL kPillScore
  LD 1 41 ; weight1
  CALL getAdjustedScore s s

  e0
  kPpillBlock
  CEQ
  MUL kPpillScore
  LD 1 41 ; weight1
  CALL getAdjustedScore s s

  ADD

  TIFEQ e0 kFruitBlock scoreOfFruit notScoreOfFruit
  scoreOfFruit:
    LD 1 15
    TIFEQ s 0 toScoreFruitIsNotPresent toScoreFruitIsPresent
    toScoreFruitIsPresent:
      LD 1 56
      MUL kFruitWeight
      LD 1 42 ; weight2
      CALL getAdjustedScore s s
      ADD
      GOTO notScoreOfFruit
    toScoreFruitIsNotPresent:
      LD 1 58 ; tick
      LD 1 40 ; distance
      MUL 127
      e0 <- ADD

      25400 ; fruit1 start
      LD 1 58 ; tick
      TIFGT s s fruit1Before notFruit1
      fruit1Before:
      TIFGT e0 25400 fruit1Lower notFruit1
      fruit1Lower:
      TIFGT 35560 e0 fruit1Upper notFruit1
      fruit1Upper:
        LD 1 56 ; fruitScore
        MUL kFruitWeight
        LD 1 42 ; weight2
        CALL getAdjustedScore s s
        ADD
      notFruit1:

      50800 ; fruit2 start
      LD 1 58 ; tick
      TIFGT s s fruit2Before notFruit2
      fruit2Before:
      TIFGT e0 50800 fruit2Lower notFruit2
      fruit2Lower:
      TIFGT 60960 e0 fruit2Upper notFruit2
      fruit2Upper:
        LD 1 56 ; fruitScore
        MUL kFruitWeight
        LD 1 42 ; weight2
        CALL getAdjustedScore s s
        ADD
      notFruit2:
  notScoreOfFruit:

  TIFEQ e3 kAAA scoreOfGhost checkScoreOfGhost
  checkScoreOfGhost:

  TIFEQ e0 kBlockWithEdibleGhost scoreOfGhost notScoreOfGhost
  scoreOfGhost:
    LD 1 61
    0
    CEQ
    MUL 200

    LD 1 61
    1
    CEQ
    MUL 400

    LD 1 61
    2
    CEQ
    MUL 800

    LD 1 61
    3
    CGTE
    MUL 1600

    ADD
    ADD
    ADD

    MUL kGhostWeight

    LD 1 42 ; weight2
    CALL getAdjustedScore s s

    LD 1 9
    e1
    e2
    CALL killCount s s s 0 e3
    MUL

    ADD
  notScoreOfGhost:

  RTN


mystep:
  ;LOG 10000


  e13 <- CAR e57 ; rand
  MUL e13 1029
  e13 <- ADD 555
  e13 <- MOD e13 65536

  CDR e57
  e58 <- CAR ; tick

  CDR e57
  CDR
  e61 <- CAR ; kill

  CDR e57
  CDR
  e63 <- CDR ; ambush count

  e13
  e58
  e61
  e63
  CONS
  CONS
  e57 <- CONS


  e51 <- 0 ; map tree

  e1 <- CALL indexer e0 kMapField


  CALL indexer e0 kLambdamanField
  e32 <- CALL indexer s kLmVitalityField

  CALL indexer e0 kLambdamanField
  e7 <- CALL indexer s kLmDirectionField


  CALL indexer e0 kLambdamanField
  e2 <- CALL indexer s kLmLocationField

  e11 <- CAR e2 ; lmX
  e12 <- CDR e2 ; lmY

  e18 <- SUB e12 1 ; north y
  e19 <- ADD e11 1 ; east x
  e20 <- ADD e12 1 ; south y
  e21 <- SUB e11 1 ; west x


  e9 <- CALL indexer e0 kGhostsField
  e15 <- CALL indexer e0 kFruitsStatusField


  e52 <- 0 ; width
  e22 <- e1
  widthCountLoop:
    ATOM e22
    TSEL widthCountDone widthCountNotDone
    widthCountNotDone:
      e22 <- CDR e22
      INC e52
    GOTO widthCountLoop
  widthCountDone:

  e53 <- 0 ; height
  e23 <- CAR e1
  heightCountLoop:
    ATOM e23
    TSEL heightCountDone heightCountNotDone
    heightCountNotDone:
      e23 <- CDR e23
      INC e53
    GOTO heightCountLoop
  heightCountDone:


  MUL e52 e53
  SUB 1
  DIV 100
  e56 <- ADD 1 ; level

  TIFEQ e56 1 fruitCherry fruitNotCherry
  fruitCherry:
    e56 <- 100
    GOTO fruitCalculated
  fruitNotCherry:

  TIFEQ e56 2 fruitStrawberry fruitNotStrawberry
  fruitStrawberry:
    e56 <- 300
    GOTO fruitCalculated
  fruitNotStrawberry:

  TIFGTE 4 e56 fruitPeach fruitNotPeach
  fruitPeach:
    e56 <- 500
    GOTO fruitCalculated
  fruitNotPeach:

  TIFGTE 6 e56 fruitApple fruitNotApple
  fruitApple:
    e56 <- 700
    GOTO fruitCalculated
  fruitNotApple:

  TIFGTE 8 e56 fruitGrapes fruitNotGrapes
  fruitGrapes:
    e56 <- 1000
    GOTO fruitCalculated
  fruitNotGrapes:

  TIFGTE 10 e56 fruitGalaxian fruitNotGalaxian
  fruitGalaxian:
    e56 <- 2000
    GOTO fruitCalculated
  fruitNotGalaxian:


  TIFGTE 12 e56 fruitBell fruitNotBell
  fruitBell:
    e56 <- 3000
    GOTO fruitCalculated
  fruitNotBell:
    e56 <- 5000

  fruitCalculated:


  ;LOG 10040


  e22 <- e1 ; row
  e17 <- 0 ; y

  e34 <- LDF blockCheck

  loopY:
    ATOM e22 ; row
    TSEL rowDone rowNotDone
    rowNotDone:
      e23 <- POPFRONT e22
      e16 <- 0 ; x

      loopX:
        ATOM e23 ; col
        TSEL colDone colNotDone
        colNotDone:
          ;e51
          ;MUL e17 e52 ; y * width
          ;ADD e16 ; y * width + x = block id
          ;CAR e23
          ;e51 <- CALL treeInsert s s s

          TIFEQ e17 e18 isNorth isNotNorth
          isNorth:
            TIFEQ e16 e11 isUpCoord isNotUpCoord
            isUpCoord:
              CAR e23
              0
              e3 <- APPLY e34 s s ; blockCheck
              GOTO hoge
            isNotUpCoord:
          isNotNorth:

          TIFEQ e16 e19 isEast isNotEast
          isEast:
            TIFEQ e17 e12 isRightCoord isNotRightCoord
            isRightCoord:
              CAR e23
              0
              e4 <- APPLY e34 s s ; blockCheck
              GOTO hoge
            isNotRightCoord:
          isNotEast:

          TIFEQ e17 e20 isSouth isNotSouth
          isSouth:
            TIFEQ e16 e11 isDownCoord isNotDownCoord
            isDownCoord:
              CAR e23
              0
              e5 <- APPLY e34 s s ; blockCheck
              GOTO hoge
            isNotDownCoord:
          isNotSouth:

          TIFEQ e16 e21 isWest isNotWest
          isWest:
            TIFEQ e17 e12 isLeftCoord isNotLeftCoord
            isLeftCoord:
              CAR e23
              0
              e6 <- APPLY e34 s s ; blockCheck
              GOTO hoge
            isNotLeftCoord:
          isNotWest:

          hoge:

        e23 <- CDR e23
        INC e16 ; ++x
        GOTO loopX

      colDone:

      INC e17 ; ++y
      GOTO loopY

    rowDone:


  ;LOG 10010


  e35 <- LDF mapAndCoordToBlock

  e48 <- LDF toScore


  ; candidate queues
  CONS e11 e18

  0
  CONS kDown 0
  CONS

  CONS
  e24 <- CONS s 0

  CONS e19 e12

  0
  CONS kLeft 0
  CONS

  CONS
  e25 <- CONS s 0

  CONS e11 e20

  0
  CONS kUp 0
  CONS

  CONS
  e26 <- CONS s 0

  CONS e21 e12

  0
  CONS kRight 0
  CONS

  CONS
  e27 <- CONS s 0

  e40 <- 0 ; distance
  e41 <- 128 ; score weight
  e42 <- 128 ; score weight

  CONS e11 e12 ; (lmX, lmY)
  e29 <- CONS s 0 ; initialize visited

  bfsLoop:
    e31 <- 0 ; continue bfs


    e36 <- 0 ; next queue

    northNextLoop:
    ATOM e24
    TSEL northNextEmpty northNextNotEmpty
    northNextNotEmpty:
      e31 <- 1 ; continue bfs

      e28 <- POPFRONT e24

      ;LOG 29553
      ;DBUG e28

      CAR e28
      e16 <- CAR ; x
      CAR e28
      e17 <- CDR ; y
      CDR e28
      e50 <- CAR ; score
      CDR e28
      CDR
      e59 <- CAR ; backward
      CDR e28
      CDR
      e62 <- CDR ; ppill path

      e30 <- APPLY e35 e16 e17 0 e62 ; mapAndCoordToBlock

      e62
      e30
      kPpillBlock
      CEQ
      ADD
      0
      e62 <- CGT

      CALL isGhost e30
      TSEL northGhost northNotGhost
      northGhost:
        kGhostRadar
        e62
        ADD
        TIFGTE s e40 northNextGhostInRange northNextGhostNotInRange
        northNextGhostInRange:
          e60 <- 1
        northNextGhostNotInRange:
      northNotGhost:

      CALL isWallOrGhost e30
      TSEL northNextIsWallOrGhost northNextIsNotWallOrGhost
      northNextIsNotWallOrGhost:
        CALL isVisited e16 e17 e29
        TSEL northNextIsVisited northNextIsNotVisited
        northNextIsNotVisited:
          CAR e28
          e29 <- CONS s e29 ; visited

          e49 <- APPLY e48 e30 e16 e17 e62 ; toScore

          e49 <- ADD e49 e50
          TIFGT e49 e44 northNextUpdateBest northNextNoUpdateBest
          northNextUpdateBest:
            e44 <- e49
          northNextNoUpdateBest:

          TIFEQ e59 kUp northSkipUp northDoUp
          northDoUp:
          e16
          e17
          SUB 1
          CONS

          e49
          CONS kDown e62
          CONS

          CONS
          e36 <- CONS s e36
          northSkipUp:

          TIFEQ e59 kRight northSkipRight northDoRight
          northDoRight:
          e16
          ADD 1
          e17
          CONS

          e49
          CONS kLeft e62
          CONS

          CONS
          e36 <- CONS s e36
          northSkipRight:

          TIFEQ e59 kDown northSkipDown northDoDown
          northDoDown:
          e16
          e17
          ADD 1
          CONS

          e49
          CONS kUp e62
          CONS

          CONS
          e36 <- CONS s e36
          northSkipDown:

          TIFEQ e59 kLeft northSkipLeft northDoLeft
          northDoLeft:
          e16
          SUB 1
          e17
          CONS

          e49
          CONS kRight e62
          CONS

          CONS
          e36 <- CONS s e36
          northSkipLeft:

          GOTO northNextLoop
        northNextIsVisited:
          GOTO northNextLoop
      northNextIsWallOrGhost:
        e30
        kBlockWithGhost
        CEQ
        TSEL northNextIsGhost northNextLoop
        northNextIsGhost:

        TIFEQ e3 kPpillBlock northNextGhostIsNotClose northCanNotProceed
        northCanNotProceed:

        TIFGTE kAvoidRadar e40 northNextGhostIsClose northNextGhostIsNotClose
        northNextGhostIsClose:
          e44 <- 0
          e36 <- 0
          GOTO northNextEmpty
        northNextGhostIsNotClose:
          GOTO northNextLoop
    northNextEmpty:

    e24 <- e36


    e37 <- 0 ; next queue

    eastNextLoop:
    ATOM e25
    TSEL eastNextEmpty eastNextNotEmpty
    eastNextNotEmpty:
      e31 <- 1 ; continue bfs

      e28 <- POPFRONT e25

      ;LOG 2966233
      ;DBUG e28

      CAR e28
      e16 <- CAR ; x
      CAR e28
      e17 <- CDR ; y
      CDR e28
      e50 <- CAR ; score
      CDR e28
      CDR
      e59 <- CAR ; backward
      CDR e28
      CDR
      e62 <- CDR ; ppill path

      e30 <- APPLY e35 e16 e17 0 e62 ; mapAndCoordToBlock

      e62
      e30
      kPpillBlock
      CEQ
      ADD
      0
      e62 <- CGT

      CALL isGhost e30
      TSEL eastGhost eastNotGhost
      eastGhost:
        kGhostRadar
        e62
        ADD
        TIFGTE s e40 eastNextGhostInRange eastNextGhostNotInRange
        eastNextGhostInRange:
          e60 <- 1
        eastNextGhostNotInRange:
      eastNotGhost:

      CALL isWallOrGhost e30
      TSEL eastNextIsWallOrGhost eastNextIsNotWallOrGhost
      eastNextIsNotWallOrGhost:
        CALL isVisited e16 e17 e29
        TSEL eastNextIsVisited eastNextIsNotVisited
        eastNextIsNotVisited:
          CAR e28
          e29 <- CONS s e29 ; visited

          e49 <- APPLY e48 e30 e16 e17 e62 ; toScore
          ;DBUG e49

          e49 <- ADD e49 e50
          TIFGT e49 e45 eastNextUpdateBest eastNextNoUpdateBest
          eastNextUpdateBest:
            e45 <- e49
          eastNextNoUpdateBest:

          TIFEQ e59 kUp eastSkipUp eastDoUp
          eastDoUp:
          e16
          e17
          SUB 1
          CONS

          e49
          CONS kDown e62
          CONS

          CONS
          e37 <- CONS s e37
          eastSkipUp:

          TIFEQ e59 kRight eastSkipRight eastDoRight
          eastDoRight:
          e16
          ADD 1
          e17
          CONS

          e49
          CONS kLeft e62
          CONS

          CONS
          e37 <- CONS s e37
          eastSkipRight:

          TIFEQ e59 kDown eastSkipDown eastDoDown
          eastDoDown:
          e16
          e17
          ADD 1
          CONS

          e49
          CONS kUp e62
          CONS

          CONS
          e37 <- CONS s e37
          eastSkipDown:

          TIFEQ e59 kLeft eastSkipLeft eastDoLeft
          eastDoLeft:
          e16
          SUB 1
          e17
          CONS

          e49
          CONS kRight e62
          CONS

          CONS
          e37 <- CONS s e37
          eastSkipLeft:

          GOTO eastNextLoop
        eastNextIsVisited:
          GOTO eastNextLoop
      eastNextIsWallOrGhost:
        e30
        kBlockWithGhost
        CEQ
        TSEL eastNextIsGhost eastNextLoop
        eastNextIsGhost:

        TIFEQ e4 kPpillBlock eastNextGhostIsNotClose eastCanNotProceed
        eastCanNotProceed:

        TIFGTE kAvoidRadar e40 eastNextGhostIsClose eastNextGhostIsNotClose
        eastNextGhostIsClose:
          e45 <- 0
          e37 <- 0
          GOTO eastNextEmpty
        eastNextGhostIsNotClose:
          GOTO eastNextLoop
    eastNextEmpty:

    e25 <- e37


    e38 <- 0 ; next queue

    southNextLoop:
    ATOM e26
    TSEL southNextEmpty southNextNotEmpty
    southNextNotEmpty:
      e31 <- 1 ; continue bfs

      e28 <- POPFRONT e26

      ;LOG 293933
      ;DBUG e28

      CAR e28
      e16 <- CAR ; x
      CAR e28
      e17 <- CDR ; y
      CDR e28
      e50 <- CAR ; score
      CDR e28
      CDR
      e59 <- CAR ; backward
      CDR e28
      CDR
      e62 <- CDR ; ppill path

      e30 <- APPLY e35 e16 e17 0 e62 ; mapAndCoordToBlock

      e62
      e30
      kPpillBlock
      CEQ
      ADD
      0
      e62 <- CGT

      CALL isGhost e30
      TSEL southGhost southNotGhost
      southGhost:
        kGhostRadar
        e62
        ADD
        TIFGTE s e40 southNextGhostInRange southNextGhostNotInRange
        southNextGhostInRange:
          e60 <- 1
        southNextGhostNotInRange:
      southNotGhost:

      CALL isWallOrGhost e30
      TSEL southNextIsWallOrGhost southNextIsNotWallOrGhost
      southNextIsNotWallOrGhost:
        CALL isVisited e16 e17 e29
        TSEL southNextIsVisited southNextIsNotVisited
        southNextIsNotVisited:
          CAR e28
          e29 <- CONS s e29 ; visited

          e49 <- APPLY e48 e30 e16 e17 e62 ; toScore

          e49 <- ADD e49 e50
          TIFGT e49 e46 southNextUpdateBest southNextNoUpdateBest
          southNextUpdateBest:
            e46 <- e49
          southNextNoUpdateBest:

          TIFEQ e59 kUp southSkipUp southDoUp
          southDoUp:
          e16
          e17
          SUB 1
          CONS

          e49
          CONS kDown e62
          CONS

          CONS
          e38 <- CONS s e38
          southSkipUp:

          TIFEQ e59 kRight southSkipRight southDoRight
          southDoRight:
          e16
          ADD 1
          e17
          CONS

          e49
          CONS kLeft e62
          CONS

          CONS
          e38 <- CONS s e38
          southSkipRight:

          TIFEQ e59 kDown southSkipDown southDoDown
          southDoDown:
          e16
          e17
          ADD 1
          CONS

          e49
          CONS kUp e62
          CONS

          CONS
          e38 <- CONS s e38
          southSkipDown:

          TIFEQ e59 kLeft southSkipLeft southDoLeft
          southDoLeft:
          e16
          SUB 1
          e17
          CONS

          e49
          CONS kRight e62
          CONS

          CONS
          e38 <- CONS s e38
          southSkipLeft:

          GOTO southNextLoop
        southNextIsVisited:
          GOTO southNextLoop
      southNextIsWallOrGhost:
        e30
        kBlockWithGhost
        CEQ
        TSEL southNextIsGhost southNextLoop
        southNextIsGhost:

        TIFEQ e5 kPpillBlock southNextGhostIsNotClose southCanNotProceed
        southCanNotProceed:

        TIFGTE kAvoidRadar e40 southNextGhostIsClose southNextGhostIsNotClose
        southNextGhostIsClose:
          e46 <- 0
          e38 <- 0
          GOTO southNextEmpty
        southNextGhostIsNotClose:
          GOTO southNextLoop
    southNextEmpty:

    e26 <- e38


    e39 <- 0 ; next queue

    westNextLoop:
    ATOM e27
    TSEL westNextEmpty westNextNotEmpty
    westNextNotEmpty:
      e31 <- 1 ; continue bfs

      e28 <- POPFRONT e27

      ;LOG 2939233
      ;DBUG e28

      CAR e28
      e16 <- CAR ; x
      CAR e28
      e17 <- CDR ; y
      CDR e28
      e50 <- CAR ; score
      CDR e28
      CDR
      e59 <- CAR ; backward
      CDR e28
      CDR
      e62 <- CDR ; ppill path

      e30 <- APPLY e35 e16 e17 0 e62 ; mapAndCoordToBlock

      e62
      e30
      kPpillBlock
      CEQ
      ADD
      0
      e62 <- CGT

      CALL isGhost e30
      TSEL westGhost westNotGhost
      westGhost:
        kGhostRadar
        e62
        ADD
        TIFGTE s e40 westNextGhostInRange westNextGhostNotInRange
        westNextGhostInRange:
          e60 <- 1
        westNextGhostNotInRange:
      westNotGhost:

      CALL isWallOrGhost e30
      TSEL westNextIsWallOrGhost westNextIsNotWallOrGhost
      westNextIsNotWallOrGhost:
        CALL isVisited e16 e17 e29
        TSEL westNextIsVisited westNextIsNotVisited
        westNextIsNotVisited:
          CAR e28
          e29 <- CONS s e29 ; visited

          e49 <- APPLY e48 e30 e16 e17 e62 ; toScore

          ;LOG 77777
          ;DBUG e30
          ;DBUG e49

          e49 <- ADD e49 e50
          TIFGT e49 e47 westNextUpdateBest westNextNoUpdateBest
          westNextUpdateBest:
            e47 <- e49
          westNextNoUpdateBest:

          TIFEQ e59 kUp westSkipUp westDoUp
          westDoUp:
          e16
          e17
          SUB 1
          CONS

          e49
          kDown
          e62
          CONS
          CONS

          CONS
          e39 <- CONS s e39
          westSkipUp:

          TIFEQ e59 kRight westSkipRight westDoRight
          westDoRight:
          e16
          ADD 1
          e17
          CONS

          e49
          kLeft
          e62
          CONS
          CONS

          CONS
          e39 <- CONS s e39
          westSkipRight:

          TIFEQ e59 kDown westSkipDown westDoDown
          westDoDown:
          e16
          e17
          ADD 1
          CONS

          e49
          kUp
          e62
          CONS
          CONS

          CONS
          e39 <- CONS s e39
          westSkipDown:

          TIFEQ e59 kLeft westSkipLeft westDoLeft
          westDoLeft:
          e16
          SUB 1
          e17
          CONS

          e49
          kRight
          e62
          CONS
          CONS

          CONS
          e39 <- CONS s e39
          westSkipLeft:

          GOTO westNextLoop
        westNextIsVisited:
          GOTO westNextLoop
      westNextIsWallOrGhost:
        e30
        kBlockWithGhost
        CEQ
        TSEL westNextIsGhost westNextLoop
        westNextIsGhost:

        TIFEQ e6 kPpillBlock westNextGhostIsNotClose westCanNotProceed
        westCanNotProceed:

        TIFGTE kAvoidRadar e40 westNextGhostIsClose westNextGhostIsNotClose
        westNextGhostIsClose:
          e47 <- 0
          e39 <- 0
          GOTO westNextEmpty
        westNextGhostIsNotClose:
          GOTO westNextLoop
    westNextEmpty:

    e27 <- e39


    TIFEQ e44 0 northPathNotReached skipThreshold
    northPathNotReached:
    TIFEQ e45 0 eastPathNotReached skipThreshold
    eastPathNotReached:
    TIFEQ e46 0 southPathNotReached skipThreshold
    southPathNotReached:
    TIFEQ e47 0 westPathNotReached skipThreshold
    westPathNotReached:
      TIFGTE e40 kSearchDepthWhenUnreachable breakBfsLoop bfsThresholdNotReached
    skipThreshold:
      TIFGTE e40 kSearchDepthWhenReachable breakBfsLoop bfsThresholdNotReached

    bfsThresholdNotReached:

    e31
    TSEL notBreakBfsLoop breakBfsLoop
    notBreakBfsLoop:

    ;TIFEQ e40 0 distanceIsZero distanceIsNotZero
    ;distanceIsZero:
    ;  e41 <- 128
    ;  GOTO distanceAdjustDone 
    ;distanceIsNotZero:
      ;e41 <- SUB e41 10
      ;TIFEQ e41 0 costBecameZero costNotZero
      ;costBecameZero:
      ;  e41 <- 10
      ;costNotZero:
      e41 <- MUL e41 80
      e41 <- DIV e41 100
      e42 <- MUL e42 98
      e42 <- DIV e42 100
    ;distanceAdjustDone:

    INC e40

    GOTO bfsLoop
  breakBfsLoop:


  ;LOG 10020


  ;DBUG e40

  ;DBUG e44
  ;DBUG e45
  ;DBUG e46
  ;DBUG e47

  
  e54 <- 0 ; best score
  e14 <- 4 ; invalid direction

  e55 <- ADD e7 2
  
  e55 <- MOD e55 4 ; back direction


  TIFEQ e44 0 northLose northMaybeWin
  northMaybeWin:
  TIFGT e44 e54 northWin northMaybeDraw
  northMaybeDraw:
  TIFEQ e44 e54 northDraw northLose
  northDraw:
  TIFEQ e55 kUp northLose northWin ; back
  northWin:
    e14 <- kUp
    e54 <- e44
  northLose:

  TIFEQ e45 0 eastLose eastMaybeWin
  eastMaybeWin:
  TIFGT e45 e54 eastWin eastMaybeDraw
  eastMaybeDraw:
  TIFEQ e45 e54 eastDraw eastLose
  eastDraw:
  TIFEQ e55 kRight eastLose eastWin ; back
  eastWin:
    e14 <- kRight
    e54 <- e45
  eastLose:

  TIFEQ e46 0 southLose southMaybeWin
  southMaybeWin:
  TIFGT e46 e54 southWin southMaybeDraw
  southMaybeDraw:
  TIFEQ e46 e54 southDraw southLose
  southDraw:
  TIFEQ e55 kDown southLose southWin ; back
  southWin:
    e14 <- kDown
    e54 <- e46
  southLose:

  TIFEQ e47 0 westLose westMaybeWin
  westMaybeWin:
  TIFGT e47 e54 westWin westMaybeDraw
  westMaybeDraw:
  TIFEQ e47 e54 westDraw westLose
  westDraw:
  TIFEQ e55 kLeft westLose westWin ; back
  westWin:
    e14 <- kLeft
    e54 <- e47
  westLose:


  TIFEQ e14 4 bfsFail bfsSuccess
  bfsSuccess:
    ;LOG 10030
    ;DBUG e54
    ;DBUG e14


    TIFGT e63 kAmbushLimit notAvoidPpill okToAvoid
    okToAvoid:

    TIFEQ e60 0 avoidPpill notAvoidPpill
    avoidPpill:

    INC e63

    TIFEQ e14 kUp bfsResultUp bfsResultNotUp
    bfsResultUp:
      TIFEQ e3 kPpillBlock bfsResultUpPpill bfsResultNotUp
      bfsResultUpPpill:

      TIFEQ e4 kWallBlock avoidUpByRight noAvoidUpByRight
      avoidUpByRight:
        TCALL ticker kRight
      noAvoidUpByRight:

      TIFEQ e6 kWallBlock avoidUpByLeft noAvoidUpByLeft
      avoidUpByLeft:
        TCALL ticker kLeft
      noAvoidUpByLeft:

      TCALL ticker kDown
    bfsResultNotUp:

    TIFEQ e14 kRight bfsResultRight bfsResultNotRight
    bfsResultRight:
      TIFEQ e4 kPpillBlock bfsResultRightPpill bfsResultNotRight
      bfsResultRightPpill:

      TIFEQ e3 kWallBlock avoidRightByUp noAvoidRightByUp
      avoidRightByUp:
        TCALL ticker kUp
      noAvoidRightByUp:

      TIFEQ e5 kWallBlock avoidRightByDown noAvoidRightByDown
      avoidRightByDown:
        TCALL ticker kDown
      noAvoidRightByDown:

      TCALL ticker kLeft
    bfsResultNotRight:

    TIFEQ e14 kDown bfsResultDown bfsResultNotDown
    bfsResultDown:
      TIFEQ e5 kPpillBlock bfsResultDownPpill bfsResultNotDown
      bfsResultDownPpill:

      TIFEQ e4 kWallBlock avoidDownByRight noAvoidDownByRight
      avoidDownByRight:
        TCALL ticker kRight
      noAvoidDownByRight:

      TIFEQ e5 kWallBlock avoidDownByLeft noAvoidDownByLeft
      avoidDownByLeft:
        TCALL ticker kLeft
      noAvoidDownByLeft:

      TCALL ticker kUp
    bfsResultNotDown:

    TIFEQ e14 kLeft bfsResultLeft bfsResultNotLeft
    bfsResultLeft:
      TIFEQ e6 kPpillBlock bfsResultLeftPpill bfsResultNotLeft
      bfsResultLeftPpill:

      TIFEQ e3 kWallBlock avoidLeftByUp noAvoidLeftByUp
      avoidLeftByUp:
        TCALL ticker kUp
      noAvoidLeftByUp:

      TIFEQ e5 kWallBlock avoidLeftByDown noAvoidLeftByDown
      avoidLeftByDown:
        TCALL ticker kDown
      noAvoidLeftByDown:

      TCALL ticker kRight
    bfsResultNotLeft:

    notAvoidPpill:

    e63 <- 0

    TCALL ticker e14
  bfsFail:


  LOG 10050


  TIFEQ e3 kPpillBlock upIsPpill upIsNotPpill
  upIsPpill:
    TCALL ticker kUp
  upIsNotPpill:

  TIFEQ e4 kPpillBlock rightIsPpill rightIsNotPpill
  rightIsPpill:
    TCALL ticker kRight
  rightIsNotPpill:

  TIFEQ e5 kPpillBlock downIsPpill downIsNotPpill
  downIsPpill:
    TCALL ticker kDown
  downIsNotPpill:

  TIFEQ e6 kPpillBlock leftIsPpill leftIsNotPpill
  leftIsPpill:
    TCALL ticker kLeft
  leftIsNotPpill:


  TIFEQ e3 kPillBlock upIsPill upIsNotPill
  upIsPill:
    TCALL ticker kUp
  upIsNotPill:

  TIFEQ e4 kPillBlock rightIsPill rightIsNotPill
  rightIsPill:
    TCALL ticker kRight
  rightIsNotPill:

  TIFEQ e5 kPillBlock downIsPill downIsNotPill
  downIsPill:
    TCALL ticker kDown
  downIsNotPill:

  TIFEQ e6 kPillBlock leftIsPill leftIsNotPill
  leftIsPill:
    TCALL ticker kLeft
  leftIsNotPill:


  e33 <- LDF shouldAimPill


  ;LOG 10060

  ;LOG 100600

  CALL getVector kUp
  0
  0
  0
  e33
  APPLY s s s s s s ; shouldAimPill
  TSEL canTowardPill cannotTowardPill
  canTowardPill:
    TCALL ticker kUp
  cannotTowardPill:

  ;LOG 100601

  CALL getVector kRight
  0
  0
  0
  e33
  APPLY s s s s s s ; shouldAimPill
  TSEL seePillRight doNotSeePillRight
  seePillRight:
    TCALL ticker kRight
  doNotSeePillRight:

  ;LOG 100602

  CALL getVector kDown
  0
  0
  0
  e33
  APPLY s s s s s s ; shouldAimPill
  TSEL seePillDown doNotSeePillDown
  seePillDown:
    TCALL ticker kDown
  doNotSeePillDown:

  ;LOG 100603

  CALL getVector kLeft
  0
  0
  0
  e33
  APPLY s s s s s s ; shouldAimPill
  TSEL seePillLeft doNotSeePillLeft
  seePillLeft:
    TCALL ticker kLeft
  doNotSeePillLeft:


  LOG 10070


  e13 <- DIV e13 13
  e13 <- MOD e13 3


  tryNextDirection:


  ;LOG 10080


  ; create direction
  e14 <- ADD e13 3
  e14 <- CALL addMod4 e14 e7

  TIFEQ e14 kUp facingNorth notFacingNorth
  facingNorth:
    ;LOG 19090
    ;DBUG e3
    e3
    GOTO notFacingWest
  notFacingNorth:

  TIFEQ e14 kRight facingEast notFacingEast
  facingEast:
    ;LOG 19091
    ;DBUG e3
    e4
    GOTO notFacingWest
  notFacingEast:

  TIFEQ e14 kDown facingSouth notFacingSouth
  facingSouth:
    ;LOG 19092
    ;DBUG e3
    e5
    GOTO notFacingWest
  notFacingSouth:

  TIFEQ e14 kLeft facingWest notFacingWest
  facingWest:
    ;LOG 19093
    ;DBUG e3
    e6
  notFacingWest:

  CALL isWallOrGhost s
  TSEL facingWallOrGhost notFacingWallOrGhost
  notFacingWallOrGhost:
    e11
    e12
    CALL getVector e14

    CALL addVector2D s s s s

    CALL getVector e14

    CALL addVector2D s s s s

    CALL getGhost s s e9
    ATOM

    TSEL ghostIsNotComing ghostIsComing
    ghostIsNotComing:
      ;LOG 90001
      ;DBUG e14
      TCALL ticker e14
    ghostIsComing:
  facingWallOrGhost:


  ; next candidate
  INC e13
  e13 <- MOD e13 3


  INC e10

  TIFEQ e10 5 giveUp tryNextDirection
  giveUp:
    ;LOG 10090

    CALL addMod4 e7 2
    TCALL ticker s


isPillOrPpill:
  TIFEQ e0 kPpillBlock isPpill isNotPpill
  isPpill:
    RTN 1
  isNotPpill:
    TIFEQ e0 kPillBlock isPill isNotPill
    isPill:
      RTN 1
    isNotPill:
      TIFEQ e0 kBlockWithEdibleGhost isEG isNotEG
      isEG:
        RTN 1
      isNotEG:
        RTN 0


getGhost:
  ATOM e2 ; kGhostsFiled
  TSEL ghostNotFound mayFindGhost
  ghostNotFound:
    RTN 0
  mayFindGhost:
    CAR e2 ; ghost entry
    CDR
    CAR ; location
    CAR ; x

    TIFEQ s e0 ghostXMatchSuccess ghostXMatchFail
    ghostXMatchFail:
      e0
      e1
      CDR e2
      TCALL getGhost s s s
    ghostXMatchSuccess:
      CAR e2 ; ghost entry
      CDR
      CAR ; location
      CDR ; y

      TIFEQ s e1 ghostYMatchSuccess ghostYMatchFail
      ghostYMatchFail:
        e0
        e1
        CDR e2
        TCALL getGhost s s s
      ghostYMatchSuccess:
        CAR e2
        RTN


isVisited:
  ATOM e2
  TSEL visitedIsEmpty visitedIsNotEmpty
  visitedIsEmpty:
    RTN 0
  visitedIsNotEmpty:
    CAR e2
    CAR

    TIFEQ s e0 visitedXMatched visitedXDidNotMatch
    visitedXDidNotMatch:
      e0
      e1
      CDR e2
      TCALL isVisited s s s
    visitedXMatched:
      CAR e2
      CDR

      TIFEQ s e1 visitedYMatched visitedYDidNotMatch
      visitedYDidNotMatch:
        e0
        e1
        CDR e2
        TCALL isVisited s s s
      visitedYMatched:
        RTN 1


isWallOrGhost:
  TIFEQ e0 kWallBlock isWall isNotWall
  isWall:
    RTN 1
  isNotWall:
    e0
    kBlockWithGhost
    CEQ
    RTN


isGhost:
  TIFEQ e0 kBlockWithGhost isG isNotG
  isG:
    RTN 1
  isNotG:
    e0
    kBlockWithEdibleGhost
    CEQ
    RTN


getVector:
  TIFEQ e0 kUp isUpDir isNotUpDir
  isUpDir:
    RTN 0 255
  isNotUpDir:

  TIFEQ e0 kRight isRightDir isNotRightDir
  isRightDir:
    RTN 1 0
  isNotRightDir:

  TIFEQ e0 kDown isDownDir isNotDownDir
  isDownDir:
    RTN 0 1
  isNotDownDir:

  TIFEQ e0 kLeft isLeftDir isNotLeftDir
  isLeftDir:
    RTN 255 0
  isNotLeftDir:


addVector2D:
  e0 <- ADD e0 e2

  TIFGTE e0 256 addVector2DXOverflow addVector2DXNotOverflow
  addVector2DXOverflow:
    e0 <- SUB e0 256
  addVector2DXNotOverflow:
    e0

  e1 <- ADD e1 e3

  TIFGTE e1 256 addVector2DYOverflow addVector2DYNotOverflow
  addVector2DYOverflow:
    e1 <- SUB e1 256
  addVector2DYNotOverflow:
    e1

  RTN


unreached:
  STOP


