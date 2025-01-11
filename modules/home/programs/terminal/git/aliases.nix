{
  aliases = {
    a = "add";
    ap = "add -p";
    ac = "!git add . && git commit -am";

    c = "commit --verbose";
    ca = "commit --verbose -a";
    cam = "commit -am";
    m = "commit --verbose --ammend";

    co = "checkout";
    cob = "checkout -b";
    com = "checkout master";
    cod = "checkout dev";

    p = "push";

    s = "status -sb";

    st = "stash";
    sl = "stash list";

    d = "diff";
    ds = "diff --start";
    dc = "diff --cached";

    rao = "remote add origin";

    save = "!git add -A && git commit -m 'SAVEPOINT'";
  };

  shell = {
  };
}
