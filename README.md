# 🪙 BattleRoyaleChain     
    
**An on-chain battle royale game built entirely in Solidity.**  
     
> No frontend. No mercy. Just pure EVM warfare.    
      
---   
 
## 🎮 What is BattleRoyaleChain?    

`BattleRoyaleChain` is a fully on-chain, turn-based battle royale strategy game inspired by **Fortnite**, designed to run entirely on the Ethereum Virtual Machine (EVM). Up to 10 players spawn on a shrinking 10×10 map, move, attack, and survive until only one remains.   
       
Every movement, every attack, and every zone update is stored immutably on-chain.    
  
---  
   
## 🗺️ Game Rules    
   
- 🌐 Max 10 players   
- 🟢 Game starts when 10 players join 
- 🕹️ Players take turns to `move("up")`, `move("down")`, `move("left")`, `move("right")`
- ⚔️ Attack adjacent players with `attack(address)`
- ☠️ Zone shrinks every 10 turns — players outside lose HP
- 🏆 Last player standing wins (off-chain reward can be added)

---

## 🔧 Tech Stack

| Layer     | Stack                            |
|-----------|----------------------------------|
| Language  | Solidity 0.8.24                  |
| Framework | Hardhat (optional)               |
| Network   | Ethereum-compatible (Sepolia, Base, Polygon) |

---

## 🚀 Quickstart

Clone the repo: 

```bash
git clone https://github.com/your-username/BattleRoyaleChain.git
cd BattleRoyaleChain
