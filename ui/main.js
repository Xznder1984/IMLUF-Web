const { invoke } = window.__TAURI__.tauri;

const urlInput = document.getElementById('url-input');
const webview = document.getElementById('webview');
const modal = document.getElementById('modal');

// Navigation
urlInput.addEventListener('keypress', async (e) => {
    if (e.key === 'Enter') {
        const url = urlInput.value;
        try {
            const resolvedUrl = await invoke('resolve_url', { url });
            webview.src = resolvedUrl;
        } catch (err) {
            alert('Error: ' + err);
        }
    }
});

document.getElementById('reload').onclick = () => webview.src = webview.src;
document.getElementById('back').onclick = () => window.history.back();
document.getElementById('forward').onclick = () => window.history.forward();

// Modal Logic
document.getElementById('btn-settings').onclick = () => modal.classList.remove('hidden');
document.getElementById('btn-close-modal').onclick = () => modal.classList.add('hidden');

// Registration
document.getElementById('btn-register').onclick = async () => {
    const domain = document.getElementById('reg-domain').value;
    const port = parseInt(document.getElementById('reg-port').value);
    const targetUrl = document.getElementById('reg-url').value || null;

    try {
        const success = await invoke('register_domain', { domain, port, targetUrl });
        if (success) alert('Domain registered successfully!');
        else alert('Registration failed. Check TLD.');
    } catch (err) {
        alert('Error: ' + err);
    }
};

// Local Server
document.getElementById('btn-start-server').onclick = async () => {
    const domain = document.getElementById('srv-domain').value;
    const dir = document.getElementById('srv-dir').value;
    const serverType = document.getElementById('srv-type').value;

    try {
        const res = await invoke('start_local_server', { domain, dir, serverType });
        alert(res);
    } catch (err) {
        alert('Error: ' + err);
    }
};
