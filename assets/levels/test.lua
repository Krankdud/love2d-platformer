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
  nextobjectid = 12,
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
      data = "eJzt2EkOwyAQBED8/0/n7kgsAZM2qpK4WMjMTB+8XKWUa/O6G71+st1ZyKNuZ8/3s1p5yWPvWfL49s88Vu8/gTyy7Oq59Uyf3X+KVf22Zlebb+2aPObuI485PbPo+Y6QxxoJ/SbUkCJhFgk1pEiYRUINKUb+O/2yRmp4st63kMf5duVBH3lkkUcWeWSRR5an39nkAQAAAAAAAAAAAABwng9HgAFG"
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
        },
        {
          id = 7,
          name = "hurt",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 304,
          width = 320,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "hurt",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 96,
          width = 48,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
