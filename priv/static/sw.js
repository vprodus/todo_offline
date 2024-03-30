/// <reference no-default-lib="true"/>
/// <reference lib="esnext" />
/// <reference lib="webworker" /> 
const self = /** @type {ServiceWorkerGlobalScope} */ (/** @type {unknown} */ (globalThis.self));

import config from "./sw.config.js";
const { cacheName, debug } = config;

// Install -------------------------

self.addEventListener("install", function(){
  debug && console.log("[Service Worker] Installed.");
})



// Activate ------------------------

self.addEventListener("activate", event => {
  debug && console.log("[Service Worker] Activated.");
  event.waitUntil(deleteOldCaches());
})

async function deleteOldCaches(){
  for (const key of await caches.keys()){
    if(key !== cacheName) {
      debug && console.log(`[Service Worker] Deleting Old Cache: VERSION ${key}`);
      await caches.delete(key);
    }
  }
}

/**
 * 
 * @param {string[]} assets - Array of assets to cache. 
 */
async function cacheAssets(assets) {
  try {
    const cache = await caches.open(casheName);
    await cache.addAll(assets);
    debug & console.log("[Service Worker] Cached assets.", assets);
  } catch (error) {
    console.log("[Service Worker] Unable to cache assets.", error);
  }
}

async function deleteAssets(assets){
  const cache = await caches.open(casheName);
  assets.forEach(async (urlPath) => {
    await cache.delete(urlPath);
  });
  debug && console.log("[Service Worker] Deleted cached assets.", assets);
}

// Fetch --------------------
self.addEventListener('fetch', event => {
  
  // Ignore non-GET requests.
  if (event.request.method.toUpperCase() !== "GET") return;

  // Ignore requests for chrome extensions.
  if (event.request.url.startsWith("chrome-extension://")) return;

  
  // Ignore LiveReloader. Only requested in dev.
  const url = new URL(event.request.url);
  if (url.pathname === "/phoenix/live_reload/frame") return;

  debug && console.log("[Service Worker] Handling fetch...");
  event.respondWith(respond(event.request));
})

/**
 * 
 * @param {Request} request
 * 
 * @returns {Promise<Response>} 
 */
async function respond(request){
  const cache = await caches.open(cacheName);
  const cachedResponse = await cache.match(request);

  // Try serving from cache first for faster load times.
  if (cachedResponse) {
    debug && console.log("[Service Worker] Found cached response.", cachedResponse);
    return cachedResponse;
  }

  // Try to fetch from network. If successful, return response. Else, return a cached or fallback response.
  try {
    const response = await fetch(request, {
      signal: (await cache.match(new Request("/chat"))) ? AbortSignal.timeout(2000) : null,
    })

    if (!(response instanceof Response)) {
      throw new Error("Invalid response from fetch.");
    }

    return response;
  } catch(error){
    debug && console.error(`[Service Worker] Failed to fetch (${request.url}).`, error);

    // If request is for root path, redirect to /chat.
    const url = new URL(request.url);
    if (url.pathname === "/") {
      return Response.redirect("/chat", 302);
    }

    // Check if cached response is available.
    const cachedResponse = await cache.match(request);
    if (cachedResponse) {
       debug && console.log("[Service Worker] Found cached response.", cachedResponse);
       return cachedResponse;
    }

    // When network is down and no cached response for the request, use a fallback response.
    debug && console.log("[Service Worker] No cached response. Using fallback response.");

    return (
      (await cache.match(new Request("/offline"))) ||
      new Response(
        `
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Chat</title>
          </head>
          <body>
            <h1>Whoops, can't connect to server...</h1>
            <p>Please check your connection or try refreshing.</p>  
            <a href="/">Refresh</a>
          </body>
        </html>
      `,
        {
          status: 503,
          headers: { "Content-Type": "text/html" },
        },
      )
    );
    
  }
}


