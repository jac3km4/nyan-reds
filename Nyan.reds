module Nyan

@replaceMethod(LoadingScreenProgressBarController)
protected cb func OnInitialize() -> Bool {
  let PixelSize = 4.0;

  let head = Layer.New()
    .Add(Bitmap.HeadBorder())
    .Add(Bitmap.HeadFill())
    .Add(Bitmap.Mouth(), new Vector2(5, 9))
    .Add(Bitmap.Square(Theme.Blackish()), new Vector2(4, 6))
    .Add(Bitmap.Square(Theme.Blackish()), new Vector2(11, 6))
    .Add(Bitmap.Pixel(Theme.White()), new Vector2(4, 6))
    .Add(Bitmap.Pixel(Theme.White()), new Vector2(11, 6))
    .Add(Bitmap.Square(Theme.Pink()), new Vector2(2, 8))
    .Add(Bitmap.Square(Theme.Pink()), new Vector2(12, 8))
    .Render(new Vector2(28, 5), PixelSize);
  
  let body = Layer.New()
    .Add(Bitmap.BodyBorder())
    .Add(Bitmap.BodyFill())
    .Add(Bitmap.BodyDots())
    .Render(new Vector2(16, 0), PixelSize);

  let paws = Layer.New()
    .Add(Bitmap.PawBorder())
    .Add(Bitmap.PawFill())
    .Add(Bitmap.PawBorder(), new Vector2(4, 0))
    .Add(Bitmap.PawFill(), new Vector2(4, 0));

  let pawsBack = paws.Render(new Vector2(17, 18), PixelSize);
  let pawsFront = paws.Render(new Vector2(30, 18), PixelSize);
  
  let tail = Layer.New()
    .Add(Bitmap.TailBorder())
    .Add(Bitmap.TailFill())
    .Render(new Vector2(10, 7), PixelSize);

  let rainbow = Layer.New()
    .Add(Bitmap.RainbowStripe(Theme.Red()))
    .Add(Bitmap.RainbowStripe(Theme.Orange()), new Vector2(0, 2))
    .Add(Bitmap.RainbowStripe(Theme.Yellow()), new Vector2(0, 4))
    .Add(Bitmap.RainbowStripe(Theme.Green()), new Vector2(0, 6))
    .Add(Bitmap.RainbowStripe(Theme.Blue()), new Vector2(0, 8))
    .Add(Bitmap.RainbowStripe(Theme.Purple()), new Vector2(0, 10));
  
  let rainbow1 = rainbow.Render(new Vector2(0, 4), PixelSize);
  let rainbow2 = rainbow.Render(new Vector2(4, 3), PixelSize);
  let rainbow3 = rainbow.Render(new Vector2(8, 4), PixelSize);
  let rainbow4 = rainbow.Render(new Vector2(12, 3), PixelSize);

  let canvas = new inkCanvas();
  canvas.AddChildWidget(rainbow1);
  canvas.AddChildWidget(rainbow2);
  canvas.AddChildWidget(rainbow3);
  canvas.AddChildWidget(rainbow4);
  canvas.AddChildWidget(tail);
  canvas.AddChildWidget(pawsBack);
  canvas.AddChildWidget(pawsFront);
  canvas.AddChildWidget(body);
  canvas.AddChildWidget(head);

  canvas.SetAnchor(inkEAnchor.TopRight);
  canvas.SetMargin(0, 80, 160, 0);

  this.GetRootCompoundWidget().RemoveAllChildren();
  this.GetRootCompoundWidget().AddChildWidget(canvas);

  Animate.MoveLinearly(rainbow1, 0.4, 0, new Vector2(0, -PixelSize));
  Animate.MoveLinearly(rainbow2, 0.4, 0, new Vector2(0, PixelSize));
  Animate.MoveLinearly(rainbow3, 0.4, 0, new Vector2(0, -PixelSize));
  Animate.MoveLinearly(rainbow4, 0.4, 0, new Vector2(0, PixelSize));
  Animate.MoveLinearly(tail, 0.2, 0, new Vector2(0, PixelSize));
  Animate.MoveLinearly(pawsBack, 0.2, 0, new Vector2(PixelSize, 0));
  Animate.MoveLinearly(pawsFront, 0.2, 0.1, new Vector2(PixelSize, 0));
  Animate.MoveLinearly(body, 0.4, 0, new Vector2(0, PixelSize));
  Animate.MoveLinearly(head, 0.2, 0, new Vector2(PixelSize, 0));
}

class Layer {
  let bitmaps: array<ref<Bitmap>>;
  let offsets: array<Vector2>;

  public static func New() -> ref<Layer> {
    return new Layer();
  }

  public func Add(layer: ref<Bitmap>, offset: Vector2) -> ref<Layer> {
    ArrayPush(this.bitmaps, layer);
    ArrayPush(this.offsets, offset);
    return this;
  }

  public func Add(layer: ref<Bitmap>) -> ref<Layer> {
    return this.Add(layer, new Vector2(0, 0));
  }

  public func Render(offset: Vector2, size: Float) -> ref<inkWidget> {
    let canvas = new inkCanvas();
    let i = 0;
    while i < ArraySize(this.bitmaps) {
      let combined = new Vector2(this.offsets[i].X + offset.X, this.offsets[i].Y + offset.Y);
      let out = this.bitmaps[i].Render(combined, size);
      canvas.AddChildWidget(out);
      i += 1;
    }
    return canvas;
  }

  public func Render(size: Float) -> ref<inkWidget> {
    return this.Render(new Vector2(0, 0), size);
  }
}

class Bitmap {
  let pixels: array<array<Int32>>;
  let color: Color;

  public static func Create(pixels: array<array<Int32>>, color: Color) -> ref<Bitmap> {
    let self = new Bitmap();
    self.pixels = pixels;
    self.color = color;
    return self;
  }

  public func Render(offset: Vector2, size: Float) -> ref<inkWidget> {
    let canvas = new inkCanvas();
    for pixel in this.pixels {
      let rect = new inkRectangle();
      rect.SetSize(size, size);
      rect.SetTintColor(this.color);
      let x = (Cast(pixel[0]) + offset.X) * size;
      let y = (Cast(pixel[1]) + offset.Y) * size;
      rect.SetTranslation(x, y);

      canvas.AddChildWidget(rect);
    }
    return canvas;
  }

  public static func HeadBorder() -> ref<Bitmap> {
    let pixels = [
      [2,0],[3,0],[11,0],[12,0],
      [1,1],[4,1],[10,1],[13,1],
      [1,2],[5,2],[9,2],[13,2],
      [1,3],[6,3],[7,3],[8,3],[13,3],
      [1,4],[13,4],
      [0,5],[14,5],
      [0,6],[14,6],
      [0,7],[14,7],
      [0,8],[14,8],
      [0,9],[14,9],
      [1,10],[13,10],
      [2,11],[12,11],
      [3,12],[4,12],[5,12],[6,12],[7,12],[8,12],[9,12],[10,12],[11,12]
    ];
    return Bitmap.Create(pixels, Theme.Blackish());
  }

  public static func HeadFill() -> ref<Bitmap> {
    let pixels = [
      [2,1],[3,1],[11,1],[12,1],
      [2,2],[3,2],[4,2],[10,2],[11,2],[12,2],
      [2,3],[3,3],[4,3],[5,3],[9,3],[10,3],[11,3],[12,3],
      [2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4],[9,4],[10,4],[11,4],[12,4],
      [1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],[8,5],[9,5],[10,5],[11,5],[12,5],[13,5],
      [1,6],[2,6],[3,6],[4,6],[5,6],[6,6],[7,6],[8,6],[9,6],[10,6],[11,6],[12,6],[13,6],
      [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[7,7],[8,7],[9,7],[10,7],[11,7],[12,7],[13,7],
      [1,8],[2,8],[3,8],[4,8],[5,8],[6,8],[7,8],[8,8],[9,8],[10,8],[11,8],[12,8],[13,8],
      [1,9],[2,9],[3,9],[4,9],[5,9],[6,9],[7,9],[8,9],[9,9],[10,9],[11,9],[12,9],[13,9],
      [2,10],[3,10],[4,10],[5,10],[6,10],[7,10],[8,10],[9,10],[10,10],[11,10],[12,10],
      [3,11],[4,11],[5,11],[6,11],[7,11],[8,11],[9,11],[10,11],[11,11]
    ];
    return Bitmap.Create(pixels, Theme.Gray());
  }

  public static func BodyBorder() -> ref<Bitmap> {
    let pixels = [
      [2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[11,0],[12,0],[13,0],[14,0],[15,0],[16,0],[17,0],[18,0],
      [1,1],[19,1],
      [0,2],[20,2],
      [0,3],[20,3],
      [0,4],[20,4],
      [0,5],[20,5],
      [0,6],[20,6],
      [0,7],[20,7],
      [0,8],[20,8],
      [0,9],[20,9],
      [0,10],[20,10],
      [0,11],[20,11],
      [0,12],[20,12],
      [0,13],[20,13],
      [0,14],[20,14],
      [0,15],[20,15],
      [1,16],[19,16],
      [2,17],[3,17],[4,17],[5,17],[6,17],[7,17],[8,17],[9,17],[10,17],[11,17],[12,17],[13,17],[14,17],[15,17],[16,17],[17,17],[18,17]
    ];
    return Bitmap.Create(pixels, Theme.Blackish());
  }

  public static func BodyFill() -> ref<Bitmap> {
    let pixels = [
      [2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1],[9,1],[10,1],[11,1],[12,1],[13,1],[14,1],[15,1],[16,1],[17,1],[18,1],
      [1,2],[2,2],[3,2],[4,2],[5,2],[6,2],[7,2],[8,2],[9,2],[10,2],[11,2],[12,2],[13,2],[14,2],[15,2],[16,2],[17,2],[18,2],[19,2],
      [1,3],[2,3],[3,3],[4,3],[5,3],[6,3],[7,3],[8,3],[9,3],[10,3],[11,3],[12,3],[13,3],[14,3],[15,3],[16,3],[17,3],[18,3],[19,3],
      [1,4],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4],[9,4],[10,4],[11,4],[12,4],[13,4],[14,4],[15,4],[16,4],[17,4],[18,4],[19,4],
      [1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],[8,5],[9,5],[10,5],[11,5],[12,5],[13,5],[14,5],[15,5],[16,5],[17,5],[18,5],[19,5],
      [1,6],[2,6],[3,6],[4,6],[5,6],[6,6],[7,6],[8,6],[9,6],[10,6],[11,6],[12,6],[13,6],[14,6],[15,6],[16,6],[17,6],[18,6],[19,6],
      [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[7,7],[8,7],[9,7],[10,7],[11,7],[12,7],[13,7],[14,7],[15,7],[16,7],[17,7],[18,7],[19,7],
      [1,8],[2,8],[3,8],[4,8],[5,8],[6,8],[7,8],[8,8],[9,8],[10,8],[11,8],[12,8],[13,8],[14,8],[15,8],[16,8],[17,8],[18,8],[19,8],
      [1,9],[2,9],[3,9],[4,9],[5,9],[6,9],[7,9],[8,9],[9,9],[10,9],[11,9],[12,9],[13,9],[14,9],[15,9],[16,9],[17,9],[18,9],[19,9],
      [1,10],[2,10],[3,10],[4,10],[5,10],[6,10],[7,10],[8,10],[9,10],[10,10],[11,10],[12,10],[13,10],[14,10],[15,10],[16,10],[17,10],[18,10],[19,10],
      [1,11],[2,11],[3,11],[4,11],[5,11],[6,11],[7,11],[8,11],[9,11],[10,11],[11,11],[12,11],[13,11],[14,11],[15,11],[16,11],[17,11],[18,11],[19,11],
      [1,12],[2,12],[3,12],[4,12],[5,12],[6,12],[7,12],[8,12],[9,12],[10,12],[11,12],[12,12],[13,12],[14,12],[15,12],[16,12],[17,12],[18,12],[19,12],
      [1,13],[2,13],[3,13],[4,13],[5,13],[6,13],[7,13],[8,13],[9,13],[10,13],[11,13],[12,13],[13,13],[14,13],[15,13],[16,13],[17,13],[18,13],[19,13],
      [1,14],[2,14],[3,14],[4,14],[5,14],[6,14],[7,14],[8,14],[9,14],[10,14],[11,14],[12,14],[13,14],[14,14],[15,14],[16,14],[17,14],[18,14],[19,14],
      [1,15],[2,15],[3,15],[4,15],[5,15],[6,15],[7,15],[8,15],[9,15],[10,15],[11,15],[12,15],[13,15],[14,15],[15,15],[16,15],[17,15],[18,15],[19,15],
      [2,16],[3,16],[4,16],[5,16],[6,16],[7,16],[8,16],[9,16],[10,16],[11,16],[12,16],[13,16],[14,16],[15,16],[16,16],[17,16],[18,16]
    ];
    return Bitmap.Create(pixels, Theme.Pink());
  }

  public static func BodyDots() -> ref<Bitmap> {
    let pixels = [
      [9,3],[11,3],
      [4,4],
      [14,6],
      [8,8],
      [5,10],
      [3,12],
      [8,13],
      [4,15]
    ];
    return Bitmap.Create(pixels, Theme.PinkDark());
  }

  public static func TailBorder() -> ref<Bitmap> {
    let pixels = [
      [0,0],[1,0],[2,0],[3,0],
      [0,1],[3,1],[4,1],
      [0,2],[1,2],[4,2],[5,2],
      [1,3],[2,3],[5,3],[6,3],
      [2,4],[3,4],[6,4],[7,4],
      [3,5],[4,5],[5,5],[6,5],
      [5,6],[6,6]
    ];
    return Bitmap.Create(pixels, Theme.Blackish());
  }

  public static func TailFill() -> ref<Bitmap> {
    let pixels = [
      [1,1],[2,1],
      [2,2],[3,2],
      [3,3],[4,3],
      [4,4],[5,4]
    ];
    return Bitmap.Create(pixels, Theme.Gray());
  }

  public static func PawBorder() -> ref<Bitmap> {
    let pixels = [
      [0,0],[3,0],
      [1,1],[2,1]
    ];
    return Bitmap.Create(pixels, Theme.Blackish());
  }

  public static func PawFill() -> ref<Bitmap> {
    let pixels = [
      [1,0],[2,0]
    ];
    return Bitmap.Create(pixels, Theme.Gray());
  }

  public static func Mouth() -> ref<Bitmap> {
    let pixels = [
      [0,0],[3,0],[6,0],
      [0,1],[1,1],[2,1],[3,1],[4,1],[5,1],[6,1]
    ];
    return Bitmap.Create(pixels, Theme.Blackish());
  }

  public static func RainbowStripe(color: Color) -> ref<Bitmap> {
    let pixels = [
      [0,0],[1,0],[2,0],[3,0],
      [0,1],[1,1],[2,1],[3,1]
    ];
    return Bitmap.Create(pixels, color);
  }

  public static func Square(color: Color) -> ref<Bitmap> {
    let pixels = [
      [0,0],[1,0],
      [0,1],[1,1]
    ];
    return Bitmap.Create(pixels, color);
  }

  public static func Pixel(color: Color) -> ref<Bitmap> {
    let pixels = [[0,0]];
    return Bitmap.Create(pixels, color);
  }
}

class Animate {
  public static func MoveLinearly(widget: ref<inkWidget>, duration: Float, delay: Float, offset: Vector2) {
    let interpolation = new inkAnimTranslation();
    interpolation.SetDuration(duration);
    interpolation.SetStartDelay(delay);

    let pos = widget.GetTranslation();
    interpolation.SetDirection(inkanimInterpolationDirection.FromTo);
    interpolation.SetType(inkanimInterpolationType.Linear);
    interpolation.SetMode(inkanimInterpolationMode.EasyInOut);
    interpolation.SetStartTranslation(pos);
    interpolation.SetEndTranslation(new Vector2(pos.X + offset.X, pos.Y + offset.Y));

    let anim = new inkAnimDef();
    anim.AddInterpolator(interpolation);

    let animOptions: inkAnimOptions;
    animOptions.loopType = inkanimLoopType.PingPong;
    animOptions.loopInfinite = true;

    widget.PlayAnimationWithOptions(anim, animOptions);
  }
}

class Theme {
  public static func Black() -> Color = new Color(Cast(0), Cast(0), Cast(0), Cast(255));
  public static func Blackish() -> Color = new Color(Cast(18), Cast(18), Cast(18), Cast(255));
  public static func White() -> Color = new Color(Cast(255), Cast(255), Cast(255), Cast(255));
  public static func Gray() -> Color = new Color(Cast(220), Cast(220), Cast(220), Cast(255));
  public static func Pink() -> Color = new Color(Cast(255), Cast(163), Cast(177), Cast(255));
  public static func PinkDark() -> Color = new Color(Cast(177), Cast(86), Cast(100), Cast(255));
  public static func Red() -> Color = new Color(Cast(238), Cast(28), Cast(36), Cast(255));
  public static func Orange() -> Color = new Color(Cast(255), Cast(194), Cast(14), Cast(255));
  public static func Yellow() -> Color = new Color(Cast(255), Cast(242), Cast(0), Cast(255));
  public static func Green() -> Color = new Color(Cast(34), Cast(177), Cast(76), Cast(255));
  public static func Blue() -> Color = new Color(Cast(78), Cast(110), Cast(242), Cast(255));
  public static func Purple() -> Color = new Color(Cast(110), Cast(50), Cast(152), Cast(255));
}
