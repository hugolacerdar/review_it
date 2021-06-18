# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReviewIt.Repo.insert!(%ReviewIt.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ReviewIt.{Repo, Post, Technology, User}

elixir =
  %Technology{
    hex_color: "#ac98b1",
    name: "Elixir",
    id: "d074e4f3-9082-4a20-8094-7f95368d54cb"
  }
  |> Repo.insert!()

phoenix =
  %Technology{
    hex_color: "#e95122",
    name: "Phoenix",
    id: "eafdbd93-1bc2-4f0f-b70b-d184beb08bd1"
  }
  |> Repo.insert!()

nodejs =
  %Technology{
    hex_color: "#7ec728",
    name: "Node.js",
    id: "9ffeb005-6879-45e7-8bd4-f6d572ddf61b"
  }
  |> Repo.insert!()

javascript =
  %Technology{
    hex_color: "#f7df1e",
    name: "JavaScript",
    id: "ef4e1e83-e4f0-4cd7-badc-cf410db0e9c7"
  }
  |> Repo.insert!()

react =
  %Technology{
    hex_color: "#61dafb",
    name: "React",
    id: "7a1badd8-ce18-4c9c-b032-1424ba07efeb"
  }
  |> Repo.insert!()

react_native =
  %Technology{
    hex_color: "#01d1f7",
    name: "React Native",
    id: "47e1c5a4-309f-4b81-a9b6-2c328447bca8"
  }
  |> Repo.insert!()

flutter =
  %Technology{
    hex_color: "#43caf6",
    name: "Flutter",
    id: "39cc57e2-deee-4298-8a31-09393eda1e9c"
  }
  |> Repo.insert!()

sql =
  %Technology{
    hex_color: "#325d87",
    name: "SQL",
    id: "f16e20db-6ff8-424c-93d1-59b146abe758"
  }
  |> Repo.insert!()

mongodb =
  %Technology{
    hex_color: "#4aa348",
    name: "MongoDB",
    id: "63cb3232-1571-4cfb-af04-6f54fb944734"
  }
  |> Repo.insert!()

html5 =
  %Technology{
    hex_color: "#ec501e",
    name: "HTML5",
    id: "62ee1f3f-2339-41db-9434-fd0afa2d3521"
  }
  |> Repo.insert!()

css3 =
  %Technology{
    hex_color: "#409ad6",
    name: "CSS3",
    id: "55587a87-5dac-4aa8-9df2-b7c4689d25e4"
  }
  |> Repo.insert!()

stack1 = [elixir, phoenix, sql]
stack2 = [elixir, phoenix, mongodb]
stack3 = [react_native, mongodb]
stack4 = [react, html5, css3, javascript]
stack5 = [nodejs, javascript, react]
stack6 = [flutter, sql]

%User{id: user1_id} =
  %{
    nickname: "Floo",
    email: "floo@doo.com",
    is_expert: false,
    picture_url: nil,
    password: "Paçoca1!"
  }
  |> User.changeset()
  |> Repo.insert!()

%User{id: user2_id} =
  %{
    nickname: "Bloo",
    email: "bloo@doo.com",
    is_expert: false,
    picture_url: nil,
    password: "Paçoca1!"
  }
  |> User.changeset()
  |> Repo.insert!()

%{
  id: "6a66b9a0-392f-4deb-9a04-b8b573796b9f",
  title: "Herpderp, shoulda check if it does really compile.",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/4536",
  creator_id: user1_id,
  star_review_id: nil
}
|> Post.changeset(stack1)
|> Repo.insert!()

%{
  id: "539aa616-83f7-4edf-b539-32f5a6621e2b",
  title: "Fucking egotistical bastard. adds expandtab to vimrc",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user1_id,
  star_review_id: nil
}
|> Post.changeset(stack2)
|> Repo.insert!()

%{
  id: "b631ab3a-4f0a-475b-a2a4-ae47cba52de0",
  title: "Review pull request #67 from Lazersmoke/fix-andys-shit Fix andys shit",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user2_id,
  star_review_id: nil
}
|> Post.changeset(stack3)
|> Repo.insert!()

%{
  id: "02ca2b91-1fba-41e9-bc6a-8e09dc550498",
  title: "Reset error count between rows. herpderp",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user2_id,
  star_review_id: nil
}
|> Post.changeset(stack4)
|> Repo.insert!()

%{
  id: "ec66ad4e-1883-4b7b-b498-a83e8ff0e9c7",
  title: "Refactored configuration not going as planned......",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user1_id,
  star_review_id: nil
}
|> Post.changeset(stack1)
|> Repo.insert!()

%{
  id: "e6e04fac-3122-4c25-9de4-3ff2feab92e6",
  title: "Fixed so the code compiles on the last push",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user2_id,
  star_review_id: nil
}
|> Post.changeset(stack5)
|> Repo.insert!()

%{
  id: "ef62ecf0-139a-41c0-9488-79dd8f0219d9",
  title: "Can't figure out what is happening to the codebase since last push",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user1_id,
  star_review_id: nil
}
|> Post.changeset(stack3)
|> Repo.insert!()

%{
  id: "3711be38-5168-451f-ad63-a4d639fc4e2e",
  title: "this doesn't really make things faster, but I tried",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user2_id,
  star_review_id: nil
}
|> Post.changeset(stack4)
|> Repo.insert!()

%{
  id: "7872555e-2d98-47b6-9e29-e401a85c84e9",
  title: "Review only the JS code please, other parts can be ignored",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user1_id,
  star_review_id: nil
}
|> Post.changeset(stack4)
|> Repo.insert!()

%{
  id: "ade151c8-3086-40aa-98bf-3de904d97f64",
  title: "Query not working on Procedure that is supposed to rank",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user2_id,
  star_review_id: nil
}
|> Post.changeset(stack6)
|> Repo.insert!()

%{
  id: "7369f463-d5e5-4971-a41e-9d8ef1a7f557",
  title: "MongoDB problems when trying to use...",
  description:
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu ante magna. Proin eget felis sapien. Quisque velit ante, vulputate.",
  code_url: "www.codehub.com/12345ds2",
  creator_id: user1_id,
  star_review_id: nil
}
|> Post.changeset(stack3)
|> Repo.insert!()
