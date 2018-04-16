return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 100,
  height = 50,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 6,
  properties = {
    ["title"] = "A Test Level"
  },
  tilesets = {
    {
      name = "grid",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../graphics/grid.png",
      imagewidth = 16,
      imageheight = 16,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "collision",
      x = 0,
      y = 0,
      width = 100,
      height = 50,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["collidable"] = true
      },
      encoding = "base64",
      compression = "zlib",
      data = "eJzt2NsKwjAURcH0/3/a9wppWpvj5jADvoRALgta9RhjHMWfs7vjnVW30GOu8sznta566VG7lh7f/tnj7fkd6JGl6sxX7/Rf53eR0GM2psfedfSYW7mL1d8RK+voMZdw3oQ9pEi4i4Q9pEi4i4Q9pHj7v6knz/0nc3fsI4Ee/VX1YI0eWfTIokcWPbLs/s6mBwAAAAAAAAAAAABAPx/7XwE9"
    },
    {
      type = "objectgroup",
      name = "entities",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "player",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "exit",
          type = " ",
          shape = "rectangle",
          x = 896,
          y = 48,
          width = 16,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
