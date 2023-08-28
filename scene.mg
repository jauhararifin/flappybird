import js "js";
import state "state";
import mem "mem";

let grass_y: i64 = 0;

fn draw_land(state: state::State) {
  js::canvas_set_fill_style(js::new_js_string("#88C2CD"));
  js::canvas_fill_rect(0, 0, state.width, state.height);

  let y = state.height;

  js::canvas_set_fill_style(js::new_js_string("#D7E494"));
  let land_h = state.height * 8 / 100;
  y = y - land_h;
  js::canvas_fill_rect(0, y, state.width, land_h);

  js::canvas_set_fill_style(js::new_js_string("#C5B44F"));
  let land_shadow_h = state.height * 5 / 1000;
  y = y - land_shadow_h;
  js::canvas_fill_rect(0, y, state.width, land_shadow_h);

  grass_y = y;
  y = y - draw_grass(state);

  js::canvas_set_fill_style(js::new_js_string("#DCFF90"));
  let grass_shadow_h = state.height * 5 / 1000;
  y = y - grass_shadow_h;
  js::canvas_fill_rect(0, y, state.width, grass_shadow_h);

  js::canvas_set_fill_style(js::new_js_string("#4B383A"));
  let land_h = state.height * 5 / 1000;
  y = y - land_h;
  js::canvas_fill_rect(0, y, state.width, land_h);

  draw_bush(state, y);

  duck_up(state, state.height / 2);
  duck_mid(state, state.height / 2);
  duck_down(state, state.height / 2);
}

fn draw_grass(state: state::State): i64 {
  let grass_h = state.height * 15 / 1000;
  let grass_w = grass_h;
  let x: i64 = -grass_w*2;

  x = x - state.distance;
  let y = grass_y - grass_h;

  js::canvas_set_fill_style(js::new_js_string("#9DF64E"));
  js::canvas_fill_rect(0, y, state.width, grass_h);
  while x < state.width + grass_w*2 {
    js::canvas_set_fill_style(js::new_js_string("#75CE1F"));
    js::canvas_fill_rect(x - grass_w*0/4, y+grass_h*0/3, grass_w, grass_h/3);

    js::canvas_set_fill_style(js::new_js_string("#75CE1F"));
    js::canvas_fill_rect(x - grass_w*1/4, y+grass_h*1/3, grass_w, grass_h/3);

    js::canvas_set_fill_style(js::new_js_string("#75CE1F"));
    js::canvas_fill_rect(x - grass_w*2/4, y+grass_h*2/3, grass_w, grass_h/3);

    x = x + grass_w * 2;
  }

  return grass_h;
}

fn draw_bush(state: state::State, y: i64) {
  let line = mem::alloc_array::<[*]u8>(55);

  line[ 0].* = "                                              ";
  line[ 1].* = "                                              ";
  line[ 2].* = "                                              ";
  line[ 3].* = "                                              ";
  line[ 4].* = "                                              ";
  line[ 5].* = "                                              ";
  line[ 6].* = "                                              ";
  line[ 7].* = "      ----                                    ";
  line[ 8].* = "    --------                                  ";
  line[ 9].* = "  ------------                       ------   ";
  line[10].* = " --------------                    ---------- ";
  line[11].* = "----------------                 -------------";
  line[12].* = "----------------      ----      --------------";
  line[13].* = "-----------------   -------    ---------------";
  line[14].* = "-----------------  ---------  ----------------";
  line[15].* = "----------------- ----------- ----------------";
  line[16].* = "----------------------------------------------";
  line[17].* = "----------------------------------------------";
  line[18].* = "----------------------------------------------";
  line[19].* = "----------------------------------------------";
  line[20].* = "----------------------------------------------";
  line[21].* = "--------------------$$$$$---------------------";
  line[22].* = "--------------------$,,,$--++++++-------------";
  line[23].* = "--------------------$,*,$--++++++-------------";
  line[24].* = "----------------$$$$$,*,$++++++++-------------";
  line[25].* = "----+++---------$,,,,,,,$++++++++-------------";
  line[26].* = "---++++--$$$$$$-$,*,*,*,$++++++++-------------";
  line[27].* = "-++++++--$,,,,$-$,*,*,*,$++++++++-------------";
  line[28].* = "-++++++--$,*,*$-$,,,,,,,$++++++++-------------";
  line[29].* = "-++++$$$$$$$$$$-$,*,*,*,$$$$$$$$$$$$$---------";
  line[30].* = "-++++$,,,,,,,,$-$,*,*,*,$,,,,,,,,,,,$---------";
  line[31].* = "-++++$*,*,*,*,$-$,,,,,,,$,*,*,*,*,*,$---------";
  line[32].* = "-++++$*,*,*,*,$-$,*,*,*,$,*,*,*,*,*,$---------";
  line[33].* = "+++++$,,,,,$$$$$$,*,*,*,$,,,,,,,,,,,$---++++++";
  line[34].* = "+++++$*,*,*$,,,,$,,,,,,,$,*,*,*,*,*,$---++++++";
  line[35].* = "+++++$*,*,*$,*,*$,*,*,*,$,*,*,*,*,*,$++-++++++";
  line[36].* = "+++++$,,,,,$,*,*$,*,*,*,$,,,,,,,,,,,$++-++++++";
  line[37].* = "+++++$*,*,*$,,,,$,,,,,,,$,*,*,*,*,*,$+++++++++";
  line[38].* = "+++++$*,*,####,,$,*###*,$,*,*,*,*,*,$+++++++++";
  line[39].* = "+++++$,,##....###,#...##$,,,,,,,,,,,$+++++++++";
  line[40].* = "+++++$###.......##......##,,##*,*,*,$+++++++++";
  line[41].* = "++++##...##.......#....#####..####*,$+++++++++";
  line[42].* = "++##.......##.....#..##...........##$+++++++++";
  line[43].* = "+#...........#....####..............##++###+++";
  line[44].* = "+#...........#..##....##..............##...##+";
  line[45].* = "#.............##........##..........##.......#";
  line[46].* = "#.............#..........#.........#..........";
  line[47].* = "..............................................";
  line[48].* = "..............................................";
  line[49].* = "..............................................";
  line[50].* = "..............................................";
  line[51].* = "..............................................";
  line[52].* = "..............................................";
  line[53].* = "..............................................";
  line[54].* = "..............................................";

  let border = js::new_js_string("#70CD87");
  let fill = js::new_js_string("#82E48C");
  let cloud = js::new_js_string("#EAFFDA");
  let wall_border = js::new_js_string("#ADD4D6");
  let wall = js::new_js_string("#DAF6CB");
  let window = js::new_js_string("#C4EDC2");
  let shadow = js::new_js_string("#DDF0CA");

  let tile = state.height * 5 / 1000;
  let w = js::strlen(line[0].*) as i64;
  let h = 55 as i64;
  let y = y - h * tile;

  let x = -w * tile;
  while x < state.width + w*tile {
    let i: i64 = 0;
    while i < h {
      let j: i64 = 0;
      while j < w {
        let c = line[i].*[j].*;
        if c == 35 { // '#'
          js::canvas_set_fill_style(border);
          js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
        } else if c == 46 { // '.'
          js::canvas_set_fill_style(fill);
          js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
        } else if c == 45 { // '-'
          js::canvas_set_fill_style(cloud);
          js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
        } else if c == 36 { // '$'
          js::canvas_set_fill_style(wall_border);
          js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
        } else if c == 44 { // ','
          js::canvas_set_fill_style(wall);
          js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
        } else if c == 42 { // '*'
          js::canvas_set_fill_style(window);
          js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
        } else if c == 43 { // '+'
          js::canvas_set_fill_style(shadow);
          js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
        } else {
        }
        j = j + 1;
      }
      i = i + 1;
    }

    x = x + w*tile;
  }

  mem::dealloc_array::<[*]u8>(line);
}

fn duck_up(state: state::State, y: i64) {
  let line = mem::alloc_array::<[*]u8>(12);

  line[ 0].* = "      ######     ";
  line[ 1].* = "    ##sss#ww#    ";
  line[ 2].* = "   #ssyy#wwww#   ";
  line[ 3].* = " ####yyy#gww#w#  ";
  line[ 4].* = "#wwww#yy#gww#w#  ";
  line[ 5].* = "#wwwww#yy#gwww#  ";
  line[ 6].* = "#swwws#yyy###### ";
  line[ 7].* = " #sss#yyy#rrrrrr#";
  line[ 8].* = "  ###ooo#r###### ";
  line[ 9].* = "  #oooooo#rrrrr# ";
  line[10].* = "   ##ooooo#####  ";
  line[11].* = "     #####       ";

  let border = js::new_js_string("#533846");
  js::debug_i64(border.start as i64);
  js::debug_i64(border.start[0].* as i64);
  js::debug_i64(border.start[1].* as i64);
  js::debug_i64(border.start[2].* as i64);
  js::debug_i64(border.len as i64);
  let white = js::new_js_string("#FAFAFA");
  let shadow = js::new_js_string("#FAD78C");
  let yellow = js::new_js_string("#F8B733");
  let red = js::new_js_string("#FC3800");
  let orange = js::new_js_string("#E0802C");
  let green = js::new_js_string("#D7E6CC");

  let tile = state.height * 5 / 1000;
  let w = js::strlen(line[0].*) as i64;
  let h = 12 as i64;
  let y = y - h * tile;

  let x = (state.width - w*tile)/2;

  let i: i64 = 0;
  while i < h {
    let j: i64 = 0;
    while j < w {
      let c = line[i].*[j].*;
      if c == 35 { // '#'
        js::canvas_set_fill_style(border);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 119 { // 'w'
        js::canvas_set_fill_style(white);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 115 { // 's'
        js::canvas_set_fill_style(shadow);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 121 { // 'y'
        js::canvas_set_fill_style(yellow);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 114 { // 'r'
        js::canvas_set_fill_style(red);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 111 { // 'o'
        js::canvas_set_fill_style(orange);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 103 { // 'g'
        js::canvas_set_fill_style(green);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else {
      }
      j = j + 1;
    }
    i = i + 1;
  }

  mem::dealloc_array::<[*]u8>(line);
}

fn duck_mid(state: state::State, y: i64) {
  let line = mem::alloc_array::<[*]u8>(12);

  line[ 0].* = "      ######     ";
  line[ 1].* = "    ##sss#ww#    ";
  line[ 2].* = "   #ssyy#wwww#   ";
  line[ 3].* = "  #syyyy#gww#w#  ";
  line[ 4].* = " #yyyyyy#gww#w#  ";
  line[ 5].* = " #####yyy#gwww#  ";
  line[ 6].* = "#wwwww#yyy###### ";
  line[ 7].* = "#swwws#yy#rrrrrr#";
  line[ 8].* = " #####oo#r###### ";
  line[ 9].* = "  #oooooo#rrrrr# ";
  line[10].* = "   ##ooooo#####  ";
  line[11].* = "     #####       ";

  let border = js::new_js_string("#533846");
  js::debug_i64(border.start as i64);
  js::debug_i64(border.start[0].* as i64);
  js::debug_i64(border.start[1].* as i64);
  js::debug_i64(border.start[2].* as i64);
  js::debug_i64(border.len as i64);
  let white = js::new_js_string("#FAFAFA");
  let shadow = js::new_js_string("#FAD78C");
  let yellow = js::new_js_string("#F8B733");
  let red = js::new_js_string("#FC3800");
  let orange = js::new_js_string("#E0802C");
  let green = js::new_js_string("#D7E6CC");

  let tile = state.height * 5 / 1000;
  let w = js::strlen(line[0].*) as i64;
  let h = 12 as i64;
  let y = y - h * tile;

  let x = (state.width + 2*w*tile)/2;

  let i: i64 = 0;
  while i < h {
    let j: i64 = 0;
    while j < w {
      let c = line[i].*[j].*;
      if c == 35 { // '#'
        js::canvas_set_fill_style(border);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 119 { // 'w'
        js::canvas_set_fill_style(white);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 115 { // 's'
        js::canvas_set_fill_style(shadow);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 121 { // 'y'
        js::canvas_set_fill_style(yellow);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 114 { // 'r'
        js::canvas_set_fill_style(red);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 111 { // 'o'
        js::canvas_set_fill_style(orange);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 103 { // 'g'
        js::canvas_set_fill_style(green);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else {
      }
      j = j + 1;
    }
    i = i + 1;
  }

  mem::dealloc_array::<[*]u8>(line);
}

fn duck_down(state: state::State, y: i64) {
  let line = mem::alloc_array::<[*]u8>(12);

  line[ 0].* = "      ######     ";
  line[ 1].* = "    ##sss#ww#    ";
  line[ 2].* = "   #ssyy#wwww#   ";
  line[ 3].* = "  #syyyy#gww#w#  ";
  line[ 4].* = " #yyyyyy#gww#w#  ";
  line[ 5].* = " #yyyyyyy#gwww#  ";
  line[ 6].* = " #####yyyy###### ";
  line[ 7].* = "#swwws#yy#rrrrrr#";
  line[ 8].* = "#wwww#oo#r###### ";
  line[ 9].* = "#wws#oooo#rrrrr# ";
  line[10].* = " ####ooooo#####  ";
  line[11].* = "     #####       ";

  let border = js::new_js_string("#533846");
  js::debug_i64(border.start as i64);
  js::debug_i64(border.start[0].* as i64);
  js::debug_i64(border.start[1].* as i64);
  js::debug_i64(border.start[2].* as i64);
  js::debug_i64(border.len as i64);
  let white = js::new_js_string("#FAFAFA");
  let shadow = js::new_js_string("#FAD78C");
  let yellow = js::new_js_string("#F8B733");
  let red = js::new_js_string("#FC3800");
  let orange = js::new_js_string("#E0802C");
  let green = js::new_js_string("#D7E6CC");

  let tile = state.height * 5 / 1000;
  let w = js::strlen(line[0].*) as i64;
  let h = 12 as i64;
  let y = y - h * tile;

  let x = (state.width + 5*w*tile)/2;

  let i: i64 = 0;
  while i < h {
    let j: i64 = 0;
    while j < w {
      let c = line[i].*[j].*;
      if c == 35 { // '#'
        js::canvas_set_fill_style(border);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 119 { // 'w'
        js::canvas_set_fill_style(white);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 115 { // 's'
        js::canvas_set_fill_style(shadow);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 121 { // 'y'
        js::canvas_set_fill_style(yellow);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 114 { // 'r'
        js::canvas_set_fill_style(red);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 111 { // 'o'
        js::canvas_set_fill_style(orange);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else if c == 103 { // 'g'
        js::canvas_set_fill_style(green);
        js::canvas_fill_rect(x + j*tile, y + i*tile, tile, tile);
      } else {
      }
      j = j + 1;
    }
    i = i + 1;
  }

  mem::dealloc_array::<[*]u8>(line);
}
