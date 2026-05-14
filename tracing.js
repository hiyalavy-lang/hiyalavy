export function initCanvas(canvasId, clearId, undoId) {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext('2d');
    const clearBtn = document.getElementById(clearId);
    const undoBtn = document.getElementById(undoId);

    let drawing = false;
    let paths = [];
    let currentPath = [];

    // Canvas settings
    ctx.strokeStyle = '#00bcd4';
    ctx.lineWidth = 15;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';

    function startPosition(e) {
        drawing = true;
        currentPath = [];
        draw(e);
    }

    function finishedPosition() {
        drawing = false;
        if (currentPath.length > 0) {
            paths.push([...currentPath]);
        }
        ctx.beginPath();
    }

    function draw(e) {
        if (!drawing) return;
        
        const rect = canvas.getBoundingClientRect();
        const x = (e.clientX || e.touches[0].clientX) - rect.left;
        const y = (e.clientY || e.touches[0].clientY) - rect.top;

        currentPath.push({ x, y });

        ctx.lineTo(x, y);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(x, y);
    }

    function redraw() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        paths.forEach(path => {
            ctx.beginPath();
            path.forEach((point, index) => {
                if (index === 0) {
                    ctx.moveTo(point.x, point.y);
                } else {
                    ctx.lineTo(point.x, point.y);
                }
            });
            ctx.stroke();
        });
    }

    // Mouse Events
    canvas.addEventListener('mousedown', startPosition);
    canvas.addEventListener('mouseup', finishedPosition);
    canvas.addEventListener('mousemove', draw);

    // Touch Events
    canvas.addEventListener('touchstart', (e) => {
        e.preventDefault();
        startPosition(e);
    }, { passive: false });
    canvas.addEventListener('touchend', finishedPosition);
    canvas.addEventListener('touchmove', (e) => {
        e.preventDefault();
        draw(e);
    }, { passive: false });

    // Controls
    clearBtn.addEventListener('click', () => {
        paths = [];
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    });

    undoBtn.addEventListener('click', () => {
        paths.pop();
        redraw();
    });
}
