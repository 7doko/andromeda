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

function createFallbackIcon(name) {
  const initial = name.charAt(0).toUpperCase();

  return `
    data:image/svg+xml,
    <svg xmlns="http://www.w3.org/2000/svg" width="112" height="112">
      <rect width="100%" height="100%" rx="16" fill="%23202026"/>
      <text
        x="50%"
        y="54%"
        text-anchor="middle"
        dominant-baseline="middle"
        fill="%23785aff"
        font-family="Arial"
        font-size="54"
        font-weight="bold">
        ${initial}
      </text>
    </svg>
  `.replace(/\n|\s{2,}/g, "");
}

function updateGameIcon(image, game) {
  const thumbnailUrl =
    `https://thumbnails.roblox.com/v1/places/gameicons?placeIds=${game.placeId}&size=150x150&format=Png&isCircular=false`;

  fetch(thumbnailUrl)
    .then(response => response.json())
    .then(data => {
      const iconUrl = data?.data?.[0]?.imageUrl;

      if (iconUrl) {
        image.src = iconUrl;
      }
    })
    .catch(() => {
      // The clean fallback icon stays visible if Roblox's thumbnail request fails.
    });
}

gameList.innerHTML = supportedGames.map(game => `
  <a
    class="game-card"
    href="https://www.roblox.com/games/${game.placeId}"
    target="_blank"
    rel="noopener"
  >
    <img
      class="game-icon"
      src="${createFallbackIcon(game.name)}"
      alt="${game.name} icon"
    >

    <div>
      <h3>${game.name}</h3>
      <p>Place ID: ${game.placeId}</p>
      <span class="${game.status.toLowerCase()}">${game.status}</span>
    </div>
  </a>
`).join("");

document.querySelectorAll(".game-icon").forEach((image, index) => {
  updateGameIcon(image, supportedGames[index]);
});
