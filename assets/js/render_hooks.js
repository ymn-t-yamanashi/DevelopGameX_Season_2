export const hooks = {
    canvas: {
      mounted() {
        render(JSON.parse(this.el.dataset.canvas));
      },
      updated() {
        render(JSON.parse(this.el.dataset.canvas));
      },
    },
  };
  
  var AudioContext = window.AudioContext || window.webkitAudioContext;
  let audioCtx = new AudioContext();
  
  const render = (datas) => {
    const canvasBuffer = document.querySelector("#canvas_buffer");
    const ctxBuffer = canvasBuffer.getContext("2d");
    datas.map((data) => renderExec(ctxBuffer, data));
    const canvasArea = document.querySelector("#canvas_area");
    const ctxArea = canvasArea.getContext("2d");
    bufferImage = ctxBuffer.getImageData(0, 0, 1024, 768);
    ctxArea.putImageData(bufferImage, 0, 0);
  };
  
  const renderExec = (ctx, data) => {
    [fn_name, ...arg] = data;
    fn = renderFunction[fn_name];
    if (fn == undefined) {
      console.log("no function");
      return;
    }
    fn(ctx, arg);
  };
  
  const renderFunction = {
    fillRect: (ctx, arg) => ctx.fillRect(...arg),
    fillStyle: (ctx, arg) => (ctx.fillStyle = arg),
    strokeStyle: (ctx, arg) => (ctx.strokeStyle = arg),
    beginPath: (ctx, _arg) => ctx.beginPath(),
    stroke: (ctx, _arg) => ctx.stroke(),
    arc: (ctx, arg) => ctx.arc(...arg),
    moveTo: (ctx, arg) => ctx.moveTo(...arg),
    lineTo: (ctx, arg) => ctx.lineTo(...arg),
    drawImage: (ctx, arg) => {
      [id, x, y] = arg;
      const bufferImage = document.querySelector(id);
      console.log(bufferImage);
      ctx.drawImage(bufferImage, x, y);
    },
    font: (ctx, arg) => (ctx.font = arg),
    fillText: (ctx, arg) => ctx.fillText(...arg),
    play: (_ctx, arg) => {
      [id] = arg;
      const audio = document.querySelector(id);
      audio.currentTime = 0;
      audio.play();
    },
    oscillator: (_ctx, arg) => {
      audioCtx.close();
      audioCtx = new AudioContext();
  
      [type, frequency, sec] = arg;
  
      const oscillator = audioCtx.createOscillator();
      oscillator.type = type;
      oscillator.frequency.setValueAtTime(frequency, 0);
      oscillator.connect(audioCtx.destination);
      oscillator.start(0);
      oscillator.stop(sec);
    },
  };