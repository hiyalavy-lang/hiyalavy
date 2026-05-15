const CACHE_NAME = 'thaana-kids-v1';
const assets = [
  './',
  './index.html',
  './styles.css',
  './content.js',
  './assets/click.mp3',
  './assets/success.mp3',
  './assets/mascot_board.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(assets))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request);
    })
  );
});
