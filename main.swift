import Foundation

func printGreeting() {
    print("Hello!")
    print("Type \"move x\" to move cells")
    print("Type \"restart\" to run game again")
    print("Type \"quit\" to close this app")
}

class Field {
    var emptyI = 0
    var emptyJ = 0
    var fieldSize = 2
    var cells = [[Int]]()
    
    init() {
        var cellsOneD = shuffled()
        while (!solutionExists(cellsOneD: cellsOneD)){
            cellsOneD = shuffled()
        }
        var i = 0;
        for i in 0...fieldSize-1 {
            cells.append([])
            for _ in 0...fieldSize-1 {
                cells[i].append(Int())
            }
        }
        for j in 0...cellsOneD.count-1 {
            cells[i][j-i*fieldSize] = cellsOneD[j]
            if (cellsOneD[j]==0){
                emptyI = i
                emptyJ = j-i*fieldSize
            }
            if ((j+1)%fieldSize == 0) {
                i = i+1
            }
        }
    }
    
    func shuffled() -> [Int] {
        var cellsOneD = Array (0...fieldSize*fieldSize-1)
        for (firstUnshuffled, unshuffledCount) in zip(cellsOneD.indices, stride(from: cellsOneD.count, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = cellsOneD.index(firstUnshuffled, offsetBy: d)
            cellsOneD.swapAt(firstUnshuffled, i)
        }
        return cellsOneD
    }
    
    func solutionExists(cellsOneD: [Int]) -> Bool {
        var inv = 0
        for i in 1...cellsOneD.count-1 {
            if (cellsOneD[i] != 0) {
                for j in 0...i - 1 {
                    if (cellsOneD[j] > cellsOneD[i]) {
                        inv += 1
                    }
                }
            }
        }
        for i in 0...cellsOneD.count-1 {
            if (cellsOneD[i] == 0) {
                inv += 1 + i/fieldSize
            }
        }
        return (inv%2 == 0)
    }
    
    func display() {
        for i in 0...fieldSize-1 {
            for j in 0...fieldSize-1 {
                if (cells[i][j] == 0) {
                    print(" ", terminator: "\t")
                }
                else {
                    print(cells[i][j], terminator: "\t")
                }
            }
            print()
        }
        victory()
    }
    
    func victory() {
        var victoryCondition = true
        if (cells[fieldSize-1][fieldSize-1] != 0) {
            return
        }
        for i in 0...fieldSize-1 {
            for j in 0...fieldSize-1 {
                if (((i != fieldSize-1)||(j != fieldSize-1)) && (cells[i][j] != (j + i*fieldSize + 1))) {
                    victoryCondition = false
                    break
                }
            }
        }
        if (victoryCondition) {
            print ("You are winner! Congratulations!")
        }
    }
    
    func move(x: Int) {
        let leftBorder = (emptyJ-1>=0)
        let rightBorder = (emptyJ+1<=fieldSize-1)
        let upperBorder = (emptyI-1>=0)
        let bottomBorder = (emptyI+1<=fieldSize-1)
        var movePossible = false
        
        if leftBorder && (cells[emptyI][emptyJ-1] == x) {
            cells[emptyI][emptyJ] = x
            cells[emptyI][emptyJ-1] = 0
            emptyJ = emptyJ-1
            movePossible = true
        }
        else if rightBorder && (cells[emptyI][emptyJ+1] == x) {
            cells[emptyI][emptyJ] = x
            cells[emptyI][emptyJ+1] = 0
            emptyJ = emptyJ+1
            movePossible = true
            
        }
        else if upperBorder && (cells[emptyI-1][emptyJ] == x) {
            cells[emptyI][emptyJ] = x
            cells[emptyI-1][emptyJ] = 0
            emptyI = emptyI-1
            movePossible = true
        }
        else if bottomBorder && (cells[emptyI+1][emptyJ] == x) {
            cells[emptyI][emptyJ] = x
            cells[emptyI+1][emptyJ] = 0
            emptyI = emptyI+1
            movePossible = true
        }
        
        if (!movePossible) {
            print("Value '\(x)' can't be moved")
            
        }
    }
}

enum Command {
    case quit
    case move(x: Int)
    case restart
    case unhandled
    
    init(command: String) {
        switch command {
        case "quit":
            self = .quit
        case "restart":
            self = .restart
        default:
            self = .move(x: Int(command)!)
        }
    }
}

func main() {
    printGreeting()
    var field = Field()
    field.display()
    var command: String? = nil
    var parsedCommand: Command = .restart
    var quit = false
    repeat {
        command = readLine()
        parsedCommand = Command(command: command!)
        
        // clear screen
        print("\u{001B}")
        
        switch parsedCommand {
        case .quit:
            quit = true
        case .restart:
            print("You restarted the game")
            field = Field()
        case .move(let x):
            field.move(x: x)
        default:
            print("Cannot handle that command")
        }
        
        field.display()
        
    } while !quit
    
    print("Bye!")
}

main()

