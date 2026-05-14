import { alphabet } from './alphabet.js';

class App {
    constructor() {
        this.currentView = 'soundboard';
        this.viewContainer = document.getElementById('view-container');
        this.navButtons = document.querySelectorAll('.nav-btn');
        
        this.init();
    }

    init() {
        this.navButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                const view = btn.getAttribute('data-view');
                this.switchView(view);
            });
        });

        this.render();
    }

    switchView(view) {
        this.currentView = view;
        this.navButtons.forEach(btn => {
            btn.classList.toggle('active', btn.getAttribute('data-view') === view);
        });
        this.render();
    }

    render() {
        this.viewContainer.innerHTML = '';
        
        switch (this.currentView) {
            case 'soundboard':
                this.renderSoundboard();
                break;
            case 'tracing':
                this.renderTracing();
                break;
            case 'vocabulary':
                this.renderVocabulary();
                break;
        }
    }

    renderSoundboard() {
        const grid = document.createElement('div');
        grid.className = 'alphabet-grid';

        alphabet.forEach(item => {
            const card = document.createElement('div');
            card.className = 'letter-card';
            card.innerHTML = `
                <div class="char">${item.letter}</div>
                <div class="name">${item.name}</div>
            `;
            card.addEventListener('click', () => this.playAudio(item.audio));
            grid.appendChild(card);
        });

        this.viewContainer.appendChild(grid);
    }

    renderTracing() {
        this.viewContainer.innerHTML = `
            <div class="tracing-container">
                <h2>Select a letter to trace</h2>
                <div class="letter-selector">
                    ${alphabet.map(item => `
                        <button class="select-letter-btn" data-letter="${item.letter}">${item.letter}</button>
                    `).join('')}
                </div>
                <div id="canvas-area"></div>
            </div>
        `;

        const selector = this.viewContainer.querySelector('.letter-selector');
        selector.querySelectorAll('button').forEach(btn => {
            btn.addEventListener('click', () => {
                this.initTracingCanvas(btn.getAttribute('data-letter'));
            });
        });

        // Default to first letter
        this.initTracingCanvas(alphabet[0].letter);
    }

    initTracingCanvas(letter) {
        const canvasArea = document.getElementById('canvas-area');
        canvasArea.innerHTML = `
            <div class="canvas-wrapper">
                <div class="ghost-letter">${letter}</div>
                <canvas id="tracing-canvas" width="400" height="400"></canvas>
            </div>
            <div class="controls">
                <button class="btn-action btn-undo" id="undo-btn">Undo</button>
                <button class="btn-action btn-clear" id="clear-btn">Clear</button>
            </div>
        `;
        
        // Import tracing logic
        import('./tracing.js').then(module => {
            module.initCanvas('tracing-canvas', 'clear-btn', 'undo-btn');
        });
    }

    renderVocabulary() {
        const grid = document.createElement('div');
        grid.className = 'vocab-grid';

        alphabet.forEach(item => {
            const card = document.createElement('div');
            card.className = 'vocab-card';
            card.innerHTML = `
                <img src="assets/${item.english.toLowerCase().replace(/ /g, '_')}.png" alt="${item.english}" class="vocab-img" onerror="this.src='https://placehold.co/400x300?text=${item.english}'">
                <div class="vocab-info">
                    <span class="vocab-letter">${item.letter}</span>
                    <h3 class="vocab-word">${item.word}</h3>
                    <p class="vocab-english">${item.english}</p>
                </div>
            `;
            card.addEventListener('click', () => this.playAudio(item.wordAudio));
            grid.appendChild(card);
        });

        this.viewContainer.appendChild(grid);
    }

    playAudio(filename) {
        console.log(`Playing audio: assets/audio/${filename}`);
        // Audio playback logic (dummy for now as files don't exist)
        const audio = new Audio(`assets/audio/${filename}`);
        audio.play().catch(err => {
            console.warn("Audio file not found, playing synthetic fallback if possible or just logging.");
        });
    }
}

new App();
