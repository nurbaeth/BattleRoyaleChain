// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract BattleRoyaleChain {
    uint8 public constant MAP_SIZE = 10;
    uint8 public constant MAX_PLAYERS = 10;
    uint8 public safeZoneRadius = 5;
    uint256 public turn = 0;
    bool public gameStarted = false;

    struct Player {
        address addr;
        uint8 x;
        uint8 y;
        uint8 hp;
        bool alive;
    }

    mapping(address => Player) public players;
    address[] public playerList;

    modifier onlyAlive() {
        require(players[msg.sender].alive, "You are not alive.");
        _;
    }

    function joinGame() external {
        require(!gameStarted, "Game already started");
        require(playerList.length < MAX_PLAYERS, "Max players reached");
        require(players[msg.sender].addr == address(0), "Already joined");

        uint8 spawnX = uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp))) % MAP_SIZE);
        uint8 spawnY = uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.difficulty))) % MAP_SIZE);

        players[msg.sender] = Player(msg.sender, spawnX, spawnY, 3, true);
        playerList.push(msg.sender);

        if (playerList.length == MAX_PLAYERS) {
            gameStarted = true;
        }
    }

    function move(string calldata direction) external onlyAlive {
        Player storage p = players[msg.sender];

        if (keccak256(bytes(direction)) == keccak256("up") && p.y > 0) p.y--;
        else if (keccak256(bytes(direction)) == keccak256("down") && p.y < MAP_SIZE - 1) p.y++;
        else if (keccak256(bytes(direction)) == keccak256("left") && p.x > 0) p.x--;
        else if (keccak256(bytes(direction)) == keccak256("right") && p.x < MAP_SIZE - 1) p.x++;
        else revert("Invalid move");

        _checkZone(p);
        turn++;

        // Every 10 turns, shrink zone
        if (turn % 10 == 0 && safeZoneRadius > 1) {
            safeZoneRadius--;
        }
    }

    function attack(address target) external onlyAlive {
        require(players[target].alive, "Target not alive");

        Player storage attacker = players[msg.sender];
        Player storage victim = players[target];

        require(_isAdjacent(attacker, victim), "Not adjacent");

        victim.hp--;
        if (victim.hp == 0) {
            victim.alive = false;
        }

        turn++;
    }

    function _isAdjacent(Player memory a, Player memory b) internal pure returns (bool) {
        uint dx = a.x > b.x ? a.x - b.x : b.x - a.x;
        uint dy = a.y > b.y ? a.y - b.y : b.y - a.y;
        return dx + dy == 1;
    }

    function _checkZone(Player storage p) internal {
        uint8 center = MAP_SIZE / 2;
        uint dx = p.x > center ? p.x - center : center - p.x;
        uint dy = p.y > center ? p.y - center : center - p.y;

        if (dx > safeZoneRadius || dy > safeZoneRadius) {
            p.hp--;
            if (p.hp == 0) {
                p.alive = false;
            }
        }
    }

    function getAlivePlayers() external view returns (address[] memory) {
        uint count = 0;
        for (uint i = 0; i < playerList.length; i++) {
            if (players[playerList[i]].alive) count++;
        }

        address[] memory alive = new address[](count);
        uint j = 0;
        for (uint i = 0; i < playerList.length; i++) {
            if (players[playerList[i]].alive) {
                alive[j] = playerList[i];
                j++;
            }
        }

        return alive;
    }

    function getMyPosition() external view returns (uint8, uint8, uint8, bool) {
        Player memory p = players[msg.sender];
        return (p.x, p.y, p.hp, p.alive);
    }
}
