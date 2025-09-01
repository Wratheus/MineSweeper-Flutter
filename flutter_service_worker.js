'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"manifest.json": "3f84685f2e9b4d31682878ec5cee4b98",
"favicon-32.png": "794fc7847b407d66e2cd905ca98717f2",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"main.dart.js": "1666e30cd6845842fb03a9532da07ae1",
"version.json": "d083932d550ce211df7321c2021a3a0d",
"assets/NOTICES": "36677ddfa9e3108cd12f79e6a1e33d5f",
"assets/fonts/MaterialIcons-Regular.otf": "9528751e31180c4ff44658b7896a03be",
"assets/AssetManifest.json": "b01eb7983a1e0c510af462f9dcfa4776",
"assets/assets/sounds/dig.ogg": "447ad1e0a8d10d6693f98714811b58a5",
"assets/assets/sounds/explosion3.ogg": "a3ee3fc7d0bf243c7f6122395c626ace",
"assets/assets/sounds/menu.mp3": "cbe0be3bb6b1ebb2e553ca18549d2cda",
"assets/assets/sounds/win.wav": "4a2b8548cb46fef1f36d2040da7e8c18",
"assets/assets/sounds/explosion1.ogg": "cc23237a9e1648a35eb941eabf4ea9b7",
"assets/assets/sounds/flag.mp3": "1b58cab988e209308a90dd6df6ee96db",
"assets/assets/sounds/background.mp3": "ecacebbc76125b34dfb597554adb3082",
"assets/assets/sounds/explosion2.ogg": "2d36668f22d0b021bb297027f3e3bb8a",
"assets/assets/img/num5.png": "bba04ed91a1e3de934024e02d188c758",
"assets/assets/img/opened.png": "f88f3ab9bb21fa5b41c2304dcc6973a9",
"assets/assets/img/num6.png": "1e978b31ab173d40340e690fbbc7c8e4",
"assets/assets/img/num2.png": "0572092911430f82e30001c2a4e54d46",
"assets/assets/img/num3.png": "fd658f81d16f16f663614c8b64a68294",
"assets/assets/img/num1.png": "05dc48af4197c401bd38c4a0d895b8d1",
"assets/assets/img/icon.png": "b5eeff5cfd8bd461fda3b872315fa017",
"assets/assets/img/closed.png": "1ab778d2f6806bafb8a32599f39017d8",
"assets/assets/img/num4.png": "2a26f0817dce775e13967b87bb9735e0",
"assets/assets/img/num8.png": "90e2b7eacc8ef780fd53e88424216f33",
"assets/assets/img/zero.png": "eea9d37690d1392c57e0b4a3f2e5ac45",
"assets/assets/img/num7.png": "4c5b2719324303f69fbb177b95395ea7",
"assets/assets/img/mine.png": "2a54f38f226e4e3fad8efe00c390f1e3",
"assets/assets/img/exploded.png": "70cf2f6d60cbed9edcbf8642ec19e131",
"assets/assets/img/inform.png": "d1424921186844735de09820033d8e62",
"assets/assets/img/mistake.png": "151eee1f9fbe3dc12f5717e6011571cb",
"assets/assets/img/flagged.png": "9ce981291b48c8a22c86b82cd1620a82",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6dd39f1c13403027436ee2c8c3c8e9ce",
"assets/AssetManifest.bin": "fdbf84f469b6e48bf8822a064236a3c8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"flutter_bootstrap.js": "0b562e8ee88d1c1420bf26257459a1a1",
"favicon-16.png": "5d04853838d184ab935390fe7182a2ec",
"favicon.png": "b5eeff5cfd8bd461fda3b872315fa017",
"index.html": "3d29cf0216bdc6572fe4aa348a77e573",
"/": "3d29cf0216bdc6572fe4aa348a77e573"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
