const supportedGames = [
  { name: "Arsenal", placeId: 286090429, status: "Supported" },
  { name: "Sniper Arena", placeId: 122446657157717, status: "Supported" },
  { name: "One Tap", placeId: 90568084448279, status: "Supported" },
  { name: "Murder Mystery 2", placeId: 142823291, status: "Supported" },
  { name: "Natural Disaster Survival", placeId: 189707, status: "Supported" },
  { name: "Build A Boat For Treasure", placeId: 537413528, status: "Planned" },
  { name: "RIVALS", placeId: 17625359962, status: "Supported" },
  { name: "Blade Ball", placeId: 13772394625, status: "Supported" },
  { name: "Bloxstrike", placeId: 114234929420007, status: "Supported" },
  { name: "Da Hood", placeId: 2788229376, status: "Supported" },
  { name: "Doors", placeId: 6516141723, status: "Planned" },
  { name: "Prison Life", placeId: 155615604, status: "Supported" },
  { name: "Grow a Garden 2", placeId: 126884695634066, status: "Planned" }
];

const gameList = document.querySelector("#game-list");

gameList.innerHTML = supportedGames.map(game => `
  <a class="game-card"
     href="https://www.roblox.com/games/${game.placeId}"
     target="_blank"
     rel="noopener">
    <img
      src="https://www.roblox.com/asset-thumbnail/image?assetId=${game.placeId}&width=150&height=150&format=png"
      alt="${game.name} icon">
    <div>
      <h3>${game.name}</h3>
      <p>Place ID: ${game.placeId}</p>
      <span class="${game.status.toLowerCase()}">${game.status}</span>
    </div>
  </a>
`).join("");
