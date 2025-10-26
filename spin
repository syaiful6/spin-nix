(name spin-nix)
(description "OCaml project with Nix flake")

(config project_name
  (input (prompt "Project name"))
  (default "app"))

(config project_slug
  (input (prompt "Project slug"))
  (default (slugify :project_name))
  (rules
    ("The project slug must be lowercase and contain ASCII characters and '-' only."
      (eq :project_slug (slugify :project_slug)))))

(config project_snake
  (default (snake_case :project_slug)))

(config project_description
  (input (prompt "Description"))
  (default "A short, but powerful statement about your project")
  (rules
    ("The last character of the description cannot be a \".\" to comply with Opam"
      (neq . (last_char :project_description)))))

(config username
  (input (prompt "Name of the author")))

(config github_username
  (input (prompt "Github username"))
  (default :username))
