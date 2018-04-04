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
  nextobjectid = 2,
  properties = {},
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
      data = "eJzt2EkKwzAQRUH5/pfO3gZZnjqfpgqyEQIND+wk2xhjK/7sXR3vrLqFHnOVZ96vddZLj9q19Dj6Z4+353egR5aqM5+905/O7yKhx2xMj2/X0WNu5S5Wf0esrKPHXMJ5E/aQIuEuEvaQIuEuEvaQ4u3/pu489+/M7dpPj/70yKJHFj2y6JFFjyxff2fTAwAAAAAAAAAAAACgnx8mUwEn"
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
        }
      }
    }
  }
}
